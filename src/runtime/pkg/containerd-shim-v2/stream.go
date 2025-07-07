// Copyright (c) 2018 HyperHQ Inc.
//
// SPDX-License-Identifier: Apache-2.0
//

package containerdshim

import (
	"context"
	"fmt"
	"io"
	"net/url"
	"sync"

	"github.com/sirupsen/logrus"
)

const (
	// The buffer size used to specify the buffer for IO streams copy
	bufSize = 32 << 10

	shimLogPluginBinary = "binary"
	shimLogPluginFifo   = "fifo"
	shimLogPluginFile   = "file"
)

var (
	bufPool = sync.Pool{
		New: func() interface{} {
			buffer := make([]byte, bufSize)
			return &buffer
		},
	}
)

type stdio struct {
	Stdin   string
	Stdout  string
	Stderr  string
	Console bool
}
type IO interface {
	io.Closer
	Stdin() io.ReadCloser
	Stdout() io.Writer
	Stderr() io.Writer
}

type ttyIO struct {
	io  IO
	raw *stdio
}

func (tty *ttyIO) close() {
	tty.io.Close()
}

// newTtyIO creates a new ttyIO struct.
// ns(namespace)/id(container ID) are used for containerd binary IO.
// containerd will pass the ns/id as ENV to the binary log driver,
// and the binary log driver will use ns/id to get the log options config file.
// for example nerdctl: https://github.com/containerd/nerdctl/blob/v0.21.0/pkg/logging/logging.go#L102
func newTtyIO(ctx context.Context, ns, id, stdin, stdout, stderr string, console bool) (*ttyIO, error) {
	var err error
	var io IO

	raw := &stdio{
		Stdin:   stdin,
		Stdout:  stdout,
		Stderr:  stderr,
		Console: console,
	}

	uri, err := url.Parse(stdout)
	if err != nil {
		return nil, fmt.Errorf("unable to parse stdout uri: %w", err)
	}

	if uri.Scheme == "" {
		uri.Scheme = "fifo"
	}

	switch uri.Scheme {
	case shimLogPluginFifo:
		io, err = newPipeIO(ctx, raw)
	case shimLogPluginBinary:
		io, err = newBinaryIO(ctx, ns, id, uri)
	case shimLogPluginFile:
		io, err = newFileIO(ctx, raw, uri)
	default:
		return nil, fmt.Errorf("unknown STDIO scheme %s", uri.Scheme)
	}

	if err != nil {
		return nil, fmt.Errorf("failed to creat io stream: %w", err)
	}

	return &ttyIO{
		io:  io,
		raw: raw,
	}, nil
}

func ioCopy(shimLog *logrus.Entry, exitch, stdinCloser chan struct{}, tty *ttyIO, stdinPipe io.WriteCloser, stdoutPipe, stderrPipe io.Reader) {
	var wg sync.WaitGroup
	shimLog.Error("IO COPY STARTED")
	if tty.io.Stdin() != nil {
		shimLog.Error("STDIN BUFFER IS TRUE")
		wg.Add(1)
		go func() {
			shimLog.Error("stdin io stream copy started")
			p := bufPool.Get().(*[]byte)
			defer bufPool.Put(p)
			_, err := io.CopyBuffer(stdinPipe, tty.io.Stdin(), *p)
			// shimLog.Error("STDIN COPY BUFFER OVER")

			if err != nil {
				shimLog.Errorf("STDIN COPY BUFFER OVER :", err.Error())
			}
			// notify that we can close process's io safely.
			shimLog.Error("Printing STDIN bytes %s", string(*p))
			close(stdinCloser)
			wg.Done()
			shimLog.Error("stdin io stream copy exited")
		}()
	}

	if tty.io.Stdout() != nil {
		wg.Add(1)

		go func() {
			shimLog.Error("stdout io stream copy started")
			p := bufPool.Get().(*[]byte)
			defer bufPool.Put(p)
			_, err := io.CopyBuffer(tty.io.Stdout(), stdoutPipe, *p)
			if err != nil {
				shimLog.Errorf("STDOUT COPY BUFFER OVER", err.Error())
			}
			if tty.io.Stdin() != nil {
				// close stdin to make the other routine stop
				tty.io.Stdin().Close()
			}
			shimLog.Error("Printing OUT bytes %s", string(*p))
			wg.Done()
			shimLog.Error("stdout io stream copy exited")
		}()
	}

	if tty.io.Stderr() != nil && stderrPipe != nil {
		wg.Add(1)
		go func() {
			shimLog.Error("stderr io stream copy started")
			p := bufPool.Get().(*[]byte)
			defer bufPool.Put(p)
			_, err := io.CopyBuffer(tty.io.Stderr(), stderrPipe, *p)
			if err != nil {
				shimLog.Errorf("STDERR COPY BUFFER OVER : ", err.Error())
			}
			shimLog.Error("Printing ERR bytes %s", string(*p))
			wg.Done()
			shimLog.Error("stderr io stream copy exited")
		}()
	}

	wg.Wait()
	close(stdinCloser)
	shimLog.Error("IOCOPY: STDIN CLOSED")
	tty.close()
	shimLog.Error("IOCOPY: CLOSED TTY")
	close(exitch)
	shimLog.Error("all io stream copy goroutines exited")
}

func wc(w io.WriteCloser) error {
	if w == nil {
		return nil
	}
	return w.Close()
}
