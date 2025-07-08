<<<<<<< HEAD
<img src="https://object-storage-ca-ymq-1.vexxhost.net/swift/v1/6e4619c416ff4bd19e1c087f27a43eea/www-images-prod/openstack-logo/kata/SVG/kata-1.svg" width="900">

[![CI | Publish Kata Containers payload](https://github.com/kata-containers/kata-containers/actions/workflows/payload-after-push.yaml/badge.svg)](https://github.com/kata-containers/kata-containers/actions/workflows/payload-after-push.yaml) [![Kata Containers Nightly CI](https://github.com/kata-containers/kata-containers/actions/workflows/ci-nightly.yaml/badge.svg)](https://github.com/kata-containers/kata-containers/actions/workflows/ci-nightly.yaml)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/kata-containers/kata-containers/badge)](https://scorecard.dev/viewer/?uri=github.com/kata-containers/kata-containers)

# Kata Containers

Welcome to Kata Containers!

This repository is the home of the Kata Containers code for the 2.0 and newer
releases.

If you want to learn about Kata Containers, visit the main
[Kata Containers website](https://katacontainers.io).

## Introduction

Kata Containers is an open source project and community working to build a
standard implementation of lightweight Virtual Machines (VMs) that feel and
perform like containers, but provide the workload isolation and security
advantages of VMs.

## License

The code is licensed under the Apache 2.0 license.
See [the license file](LICENSE) for further details.

## Platform support

Kata Containers currently runs on 64-bit systems supporting the following
technologies:

| Architecture | Virtualization technology |
|-|-|
| `x86_64`, `amd64` | [Intel](https://www.intel.com) VT-x, AMD SVM |
| `aarch64` ("`arm64`")| [ARM](https://www.arm.com) Hyp |
| `ppc64le` | [IBM](https://www.ibm.com) Power |
| `s390x` | [IBM](https://www.ibm.com) Z & LinuxONE SIE |

### Hardware requirements

The [Kata Containers runtime](src/runtime) provides a command to
determine if your host system is capable of running and creating a
Kata Container:

```bash
$ kata-runtime check
```

> **Notes:**
>
> - This command runs a number of checks including connecting to the
>   network to determine if a newer release of Kata Containers is
>   available on GitHub. If you do not wish this to check to run, add
>   the `--no-network-checks` option.
>
> - By default, only a brief success / failure message is printed.
>   If more details are needed, the `--verbose` flag can be used to display the
>   list of all the checks performed.
>
> - If the command is run as the `root` user additional checks are
>   run (including checking if another incompatible hypervisor is running).
>   When running as `root`, network checks are automatically disabled.

## Getting started

See the [installation documentation](docs/install).

## Documentation

See the [official documentation](docs) including:

- [Installation guides](docs/install)
- [Developer guide](docs/Developer-Guide.md)
- [Design documents](docs/design)
  - [Architecture overview](docs/design/architecture)
  - [Architecture 3.0 overview](docs/design/architecture_3.0/)

## Configuration

Kata Containers uses a single
[configuration file](src/runtime/README.md#configuration)
which contains a number of sections for various parts of the Kata
Containers system including the [runtime](src/runtime), the
[agent](src/agent) and the [hypervisor](#hypervisors).

## Hypervisors

See the [hypervisors document](docs/hypervisors.md) and the
[Hypervisor specific configuration details](src/runtime/README.md#hypervisor-specific-configuration).

## Community

To learn more about the project, its community and governance, see the
[community repository](https://github.com/kata-containers/community). This is
the first place to go if you wish to contribute to the project.

## Getting help

See the [community](#community) section for ways to contact us.

### Raising issues

Please raise an issue
[in this repository](https://github.com/kata-containers/kata-containers/issues).

> **Note:**
> If you are reporting a security issue, please follow the [vulnerability reporting process](https://github.com/kata-containers/community#vulnerability-handling)

## Developers

See the [developer guide](docs/Developer-Guide.md).

### Components

### Main components

The table below lists the core parts of the project:

| Component | Type | Description |
|-|-|-|
| [runtime](src/runtime) | core | Main component run by a container manager and providing a containerd shimv2 runtime implementation. |
| [runtime-rs](src/runtime-rs) | core | The Rust version runtime. |
| [agent](src/agent) | core | Management process running inside the virtual machine / POD that sets up the container environment. |
| [`dragonball`](src/dragonball) | core | An optional built-in VMM brings out-of-the-box Kata Containers experience with optimizations on container workloads |
| [documentation](docs) | documentation | Documentation common to all components (such as design and install documentation). |
| [tests](tests) | tests | Excludes unit tests which live with the main code. |

### Additional components

The table below lists the remaining parts of the project:

| Component | Type | Description |
|-|-|-|
| [packaging](tools/packaging) | infrastructure | Scripts and metadata for producing packaged binaries<br/>(components, hypervisors, kernel and rootfs). |
| [kernel](https://www.kernel.org) | kernel | Linux kernel used by the hypervisor to boot the guest image. Patches are stored [here](tools/packaging/kernel). |
| [osbuilder](tools/osbuilder) | infrastructure | Tool to create "mini O/S" rootfs and initrd images and kernel for the hypervisor. |
| [kata-debug](tools/packaging/kata-debug/README.md) | infrastructure | Utility tool to gather Kata Containers debug information from Kubernetes clusters. |
| [`agent-ctl`](src/tools/agent-ctl) | utility | Tool that provides low-level access for testing the agent. |
| [`kata-ctl`](src/tools/kata-ctl) | utility | Tool that provides advanced commands and debug facilities. |
| [`trace-forwarder`](src/tools/trace-forwarder) | utility | Agent tracing helper. |
| [`runk`](src/tools/runk) | utility | Standard OCI container runtime based on the agent. |
| [`ci`](.github/workflows) | CI | Continuous Integration configuration files and scripts. |
| [`ocp-ci`](ci/openshift-ci/README.md) | CI | Continuous Integration configuration for the OpenShift pipelines. |
| [`katacontainers.io`](https://github.com/kata-containers/www.katacontainers.io) | Source for the [`katacontainers.io`](https://www.katacontainers.io) site. |
| [`Webhook`](tools/testing/kata-webhook/README.md) | utility | Example of a simple admission controller webhook to annotate pods with the Kata runtime class |

### Packaging and releases

Kata Containers is now
[available natively for most distributions](docs/install/README.md#packaged-installation-methods).

## General tests

See the [tests documentation](tests/README.md).

## Metrics tests

See the [metrics documentation](tests/metrics/README.md).

## Glossary of Terms

See the [glossary of terms](https://github.com/kata-containers/kata-containers/wiki/Glossary) related to Kata Containers.
=======
<img src="https://www.openstack.org/assets/kata/kata-vertical-on-white.png" width="150">

* [About Kata Containers](#about-kata-containers)
* [Community](#community)
    * [Join Us](#join-us)
    * [Users](#users)
    * [Contributors](#contributors)
    * [Review Team](#review-team)
    * [Resource Owners](#resource-owners)
* [Governance](#governance)
    * [Developers](#developers)
        * [Contributor](#contributor)
        * [Committer](#committer)
        * [Admin](#admin)
        * [Owner](#owner)
    * [Architecture Committee](#architecture-committee)
        * [Architecture Committee Meetings](#architecture-committee-meetings)
* [Vendoring code](#vendoring-code)
* [Vulnerability Handling](#vulnerability-handling)
    * [Reporting Vulnerabilities](#reporting-vulnerabilities)
    * [Vulnerability Disclosure Process](#vulnerability-disclosure-process)
* [Week in Review template](#week-in-review-template)

# About Kata Containers

Kata Containers is an open source project and community working to build a standard implementation of lightweight Virtual Machines (VMs) that feel and perform like containers, but provide the workload isolation and security advantages of VMs.

The Kata Containers project is designed to be architecture agnostic, run on multiple hypervisors and be compatible with the OCI specification and Kubernetes.

Kata Containers combines technology from [Intel® Clear Containers](https://github.com/clearcontainers/runtime) and [Hyper runV](https://github.com/hyperhq/runv). The code is hosted on GitHub under the Apache 2 license and the project is managed by the Open Infrastructure Foundation. To learn more about the project and organizations backing the launch, visit https://www.katacontainers.io.

# Community

Kata Containers is working to build a global, diverse and collaborative community. Anyone who is interested in supporting the technology is welcome to participate. Learn how to contribute on the [Community pages](https://katacontainers.io/community/). We are seeking different expertise and skills, ranging from development, operations, documentation, marketing, community organization and product management.

## Join Us

You can join our community on any of the following places:

* Join our [mailing list](http://lists.katacontainers.io/).

* Use the `irc.oftc.net` IRC server to join the discussions:
  * General discussions channel: [`#kata-general`](http://webchat.oftc.net/?channels=kata-general).
  * Development discussions channel: [`#kata-dev`](http://webchat.oftc.net/?channels=kata-dev).

* Get an [invite to our Slack channel](https://bit.ly/3bbRXOV).
  and then [join us on Slack](https://katacontainers.slack.com/).

* Follow us on [Twitter](https://twitter.com/KataContainers) or
  [Facebook](https://www.facebook.com/KataContainers).

## Users

See [Kata Containers installation user guides](https://github.com/kata-containers/kata-containers/blob/main/docs/install/README.md) for details on how to install Kata Containers for your preferred distribution.

## Contributors

See the [contributing guide](CONTRIBUTING.md) for details on how to contribute to the project.

## Review Team

See the [rota documentation](Rota-Process.md).

## Resource Owners

Details of which Kata Containers project resources are owned, managed or controlled by whom
are detailed on the [Areas of Interest](https://github.com/kata-containers/community/wiki/Areas-of-interest) wiki page, under the [Resource Owners](https://github.com/kata-containers/community/wiki/Areas-of-interest#resource-owners) section.

# Governance

The Kata Containers project is governed according to the ["four opens"](https://openinfra.dev/four-opens/), which are open source, open design, open development, and open community. Technical decisions are made by technical contributors and a representative Architecture Committee. The community is committed to diversity, openness, and encouraging new contributors and leaders to rise up.

## Developers

For Kata developers, there are several roles relevant to project governance:

### Contributor

A Contributor to the Kata Containers project is someone who has had code merged within the last 12 months. Contributors are eligible to vote in the Architecture Committee elections. Contributors have read only access to the Kata Containers repos on GitHub.

### Committer

Kata Containers Committers (as defined by the [kata-containers-committer team](https://github.com/orgs/kata-containers/teams/kata-containers-committer))
have the ability to merge code into the Kata Containers project.
Committers are active Contributors and participants in the project. In order to become a Committer, you must be nominated by an established Committer and approved by quorum of the active Architecture Committee via an issue against the community repo
e.g. https://github.com/kata-containers/community/issues/403. Committers have write access to the Kata Containers repos on GitHub, which
gives the ability to approve PRs, trigger the CI and merge PRs.

One of the requirements to be a committer is that you are an active Contributor to the project as adjudged by the above criteria. Assessing the list of active Contributors happens twice a year,
lining up with the Architecture Committee election cycle. At that time, people who are in the kata-containers-committer team will also be reviewed, and a list of people, who are on the team,
but who haven't been an active Contributor in the last 12 months will be created and shared with the Architecture Committee and community.
After a short review period, to allow time to check for any errors, inactive team members will be removed.

> [!Note]
> See [issue #413](https://github.com/kata-containers/community/issues/413) for a potential change in how active contribution is assessed.

### Admin

Kata Containers Admins (as defined by the [kata-containers-admin team](https://github.com/orgs/kata-containers/teams/kata-containers-admin) have admin access to
the kata-containers repo, allowing them to do actions like, change the branch protection rules for repositories, delete a repository and manage the access of others.
The Admin group is intentionally kept small, however, individuals can be granted temporary admin access to carry out tasks, like creating a secret that is used in a particular CI infrastructure.
The Admin list is reviewed and updated after each Architecture Committee election and typically contains:
- The Architecture Committee
- Optionally, some specific people that the Architecture Committee agree on adding for a specific purpose (e.g. to manage the CI)

### Owner

GitHub organization owners have complete admin access to the organization, and therefore this group is limited to a small number of individuals, for security reasons.
The owners list is reviewed and updated after each Architecture Committee election and contains:
- The Community Manager and one, or more extra people from the `OpenInfra Foundation` for redundancy and vacation cover
- The Architecture Committee
- Optionally, some specific people that the Architecture Committee agree on adding for a specific purpose (e.g. to help with repo/CI migration)

## Architecture Committee

The Architecture Committee is responsible for architectural decisions, including standardization, and making final decisions if Committers disagree. It is comprised of 7 members, who are elected by Contributors.

The current Architecture Committee members are:

- `Anastassios Nanos` ([`ananos`](https://github.com/ananos)), [`Nubificus Ltd`](https://nubificus.co.uk).
- `Aurelien Bombo` ([`sprt`](https://github.com/sprt)), [`Microsoft`](https://www.microsoft.com/en-us/).
- `Fupan Li` ([`lifupan`](https://github.com/lifupan)), [`Ant Group`](https://www.antgroup.com/en).
- `Greg Kurz` ([`gkurz`](https://github.com/gkurz)), [`Red Hat`](https://www.redhat.com).
- `Ruoqing He` ([`RuoqingHe`](https://github.com/RuoqingHe)), [`ISCAS`](http://english.is.cas.cn).
- `Steve Horsman` ([`stevenhorsman`](https://github.com/stevenhorsman)), [`IBM`](https://www.ibm.com).
- `Zvonko Kaiser` ([`zvonkok`](https://github.com/zvonkok)), [`NVIDIA`](https://www.nvidia.com).

Architecture Committee elections take place in the Autumn (3 seats available) and in the Spring (4 seats available). Anyone who has made contributions to the project will be eligible to run, and anyone who has had code merged into the Kata Containers project in the 12 months (a Contributor) before the election will be eligible to vote. There are no term limits, but in order to encourage diversity, no more than 2 of the 7 seats can be filled by any one organization.

The exact size and model for the Architecture Committee may evolve over time based on the needs and growth of the project, but the governing body will always be committed to openness, diversity and the principle that technical decisions are made by technical Contributors.

See [the elections documentation](elections) for further details.

### Architecture Committee Meetings

The Architecture Committee meets every Thursday at 1300 UTC. Agenda & call info can be found [here](https://etherpad.opendev.org/p/Kata_Containers_Architecture_Committee_Mtgs).

In order to efficiently organize the Architecture Committee (AC) meetings, maximize the benefits for the community, and be as inclusive as possible, the AC recommends following a set of [guidelines](AC-Meeting-Guidelines.md) for raising topics during the weekly meetings.

# Vendoring code

See the [vendoring documentation](VENDORING.md).

# Vulnerability Handling

Vulnerabilities in Kata are handled by the
[Vulnerability Management Team (VMT)](VMT/VMT.md).
There are generally two phases:
- The reporting of a vulnerability to the VMT
- Handling and disclosure of the vulnerability by the VMT

## Reporting Vulnerabilities

Vulnerabilities in Kata should be reported using the
[responsible disclosure](https://en.wikipedia.org/wiki/Responsible_disclosure) model.

There are two methods available to report vulnerabilities to the Kata community:

1) Report via a private issue on the [Kata Containers launchpad](https://launchpad.net/katacontainers.io)
1) Email any member of the [Kata Containers architecture committee](#architecture-committee) directly

When reporting a vulnerability via the launchpad:

- You will need to create a launchpad login account.
- Preferably, but at your discretion, create the report as "Private Security", so the VMT can assess and
  respond in a responsible manner. Only the VMT members will be able to view a "Private Security" tagged
  issue initially, until it is deemed OK to make it publicly visible.

## Vulnerability Disclosure Process

Vulnerabilities in the Kata Container project are managed by the Kata Containers
Vulnerability Management Team (VMT). Vulnerabilities are managed using a
[responsible disclosure](https://en.wikipedia.org/wiki/Responsible_disclosure) model.

Details of how to report a vulnerability, the process and procedures
used for vulnerability management, and responsibilities of the VMT members
can be found in the [VMT documentation](VMT/VMT.md).

Previous Kata Containers Security Advisories are [listed on their own page](VMT/KCSA.md).

# Week in Review template

See the [week in review report template](statusreports/REPORT_TEMPLATE.md).
>>>>>>> 6023dab06b23e26e953804c476b69bf44d9371f2
