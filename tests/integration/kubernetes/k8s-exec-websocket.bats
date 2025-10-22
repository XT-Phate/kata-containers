#!/usr/bin/env bats
#
# Copyright (c) 2024 Kata Contributors
#
# SPDX-License-Identifier: Apache-2.0
#
# Specific test for early closed stdio issue in kubectl exec via WebSocket

load "${BATS_TEST_DIRNAME}/../../common.bash"
load "${BATS_TEST_DIRNAME}/tests_common.sh"

setup() {

	get_pod_config_dir
	pod_name="wss-exec-pod"
	container_name="container"

	test_yaml_file="${pod_config_dir}/k8s-pod-wss.yaml"

    info "Creating test pod YAML file at ${test_yaml_file}"
	# Create test pod YAML with a simple busybox container a simple stdout/err script

	policy_settings_dir="$(create_tmp_policy_settings_dir "${pod_config_dir}")"

	# Allow shell commands
	sh_command="sh"
	add_exec_to_policy_settings "${policy_settings_dir}" "${sh_command}"
	
	echo_command="echo"
	add_exec_to_policy_settings "${policy_settings_dir}" "${echo_command}"
	
	sleep_command="sleep"
	add_exec_to_policy_settings "${policy_settings_dir}" "${sleep_command}"

	allowed_requests=(
		"CloseStdinRequest"
		"ReadStreamRequest"
		"WriteStreamRequest"
	)
	add_requests_to_policy_settings "${policy_settings_dir}" "${allowed_requests[@]}"

	auto_generate_policy "${policy_settings_dir}" "${test_yaml_file}"

    # Get current context's cluster & username
    CURRENT_USER=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$(kubectl config current-context)\")].context.user}")
    CURRENT_CLUSTER=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"$(kubectl config current-context)\")].context.cluster}")

    # Get that user's client-key-data
    kubectl config view --raw -o jsonpath="{.users[?(@.name==\"${CURRENT_USER}\")].user.client-key-data}" | base64 --decode > client.key
    kubectl config view --raw -o jsonpath="{.users[?(@.name==\"${CURRENT_USER}\")].user.client-certificate-data}" | base64 --decode > client.crt
    kubectl config view --raw -o jsonpath="{.clusters[?(@.name==\"${CURRENT_CLUSTER}\")].cluster.certificate-authority-data}" | base64 --decode > ca.crt


    CLUSTER_URL=$(kubectl config view --raw -o jsonpath="{.clusters[?(@.name==\"${CURRENT_CLUSTER}\")].cluster.server}")
    CLUSTER_HOST_PORT=$(echo "$CLUSTER_URL" | sed -e 's|https://||')
}

@test "TestWebsocketOutput" {

	# Create the pod
	kubectl create -f "${test_yaml_file}"

	# Wait for ready pod
	kubectl wait --for=condition=Ready --timeout=1m pod "$pod_name"

    # Use curl to open WebSocket connection
    curl \
        -s --cacert ca.crt --cert client.crt --key client.key \
        --http1.1 \
        --no-buffer \
        --header "Connection: Upgrade" \
        --header "Upgrade: websocket" \
        --header "Host: ${CLUSTER_HOST_PORT}" \
        --header "Origin: ${CLUSTER_URL}" \
        --header "Sec-WebSocket-Version: 13" \
        --header "Sec-WebSocket-Key: myRandomKey" \
        "https://${CLUSTER_HOST_PORT}/api/v1/namespaces/default/pods/${pod_name}/exec?stdout=true&stderr=true&command=sh&command=-e&command=test.sh" \
        > output.log

    # Check for exactly 1 occurrence of each error1-error2-error3 and out1-out2-out3
    for i in 1 2 3; do
        error_count=$(LC_ALL="C" grep --text -c "error${i}" output.log)
        if [ "$error_count" -ne 1 ]; then
            info "✗ Test FAILED: Expected exactly 1 occurrence of 'error${i}', found ${error_count}" >&2
            exit 1
        fi
        
        out_count=$(LC_ALL="C" grep --text -c "out${i}" output.log)
        if [ "$out_count" -ne 1 ]; then
            info "✗ Test FAILED: Expected exactly 1 occurrence of 'out${i}', found ${out_count}" >&2
            exit 1
        fi
    done

    info "✓ Test PASSED: Got expected stdout and stderr output (error1-error3 and out1-out3 each found exactly once)"
}

@test "TestWebsocketOutputWithStdin" {

	# Create the pod
	kubectl create -f "${test_yaml_file}"

	# Wait for ready pod
	kubectl wait --for=condition=Ready --timeout=$timeout pod "$pod_name"

    # Use curl to open WebSocket connection with stdin
    curl \
        -s --cacert ca.crt --cert client.crt --key client.key \
        --include \
        --http1.1 \
        --no-buffer \
        --header "Connection: Upgrade" \
        --header "Upgrade: websocket" \
        --header "Host: ${CLUSTER_HOST_PORT}" \
        --header "Origin: ${CLUSTER_URL}" \
        --header "Sec-WebSocket-Version: 13" \
        --header "Sec-WebSocket-Key: myRandomKey" \
        "https://${CLUSTER_HOST_PORT}/api/v1/namespaces/default/pods/${pod_name}/exec?stdin=true&stdout=true&stderr=true&command=sh&command=-e&command=test.sh" \
        > output.log

    # Check for exactly 1 occurrence of each error1-error2-error3 and out1-out2-out3
    for i in 1 2 3; do
        error_count=$(LC_ALL="C" grep --text -c "error${i}" output.log)
        if [ "$error_count" -ne 1 ]; then
            info "✗ Test FAILED: Expected exactly 1 occurrence of 'error${i}', found ${error_count}" >&2
            exit 1
        fi
        
        out_count=$(LC_ALL="C" grep --text -c "out${i}" output.log)
        if [ "$out_count" -ne 1 ]; then
            info "✗ Test FAILED: Expected exactly 1 occurrence of 'out${i}', found ${out_count}" >&2
            exit 1
        fi
    done

    info "✓ Test PASSED: Got expected stdout and stderr output (error1-error3 and out1-out3 each found exactly once)"
}


teardown() {
	# Show pod logs and status for debugging
	kubectl describe pod "$pod_name" || true
	kubectl logs "$pod_name" -c "$container_name" || true

	# Clean up
	kubectl delete pod "$pod_name" || true

	rm -f "${pod_config_dir}/parallel"*.log
    rm -f ca.crt client.crt client.key output.log

	delete_tmp_policy_settings_dir "${policy_settings_dir}"
}
