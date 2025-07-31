import os
from mitmproxy.io import FlowReader
from mitmproxy import http
import json

def parse_log(input_log_path, output_json_path):
    results = []
    
    # Convert paths to valid Windows paths (if necessary)
    input_log_path = os.path.normpath(input_log_path)
    output_json_path = os.path.normpath(output_json_path)

    try:
        with open(input_log_path, "rb") as f:
            reader = FlowReader(f)
            for flow in reader.stream():
                if isinstance(flow, http.HTTPFlow):
                    try:
                        entry = {
                            "host": flow.request.host,
                            "method": flow.request.method,
                            "path": flow.request.path,
                            "status_code": flow.response.status_code if flow.response else None,
                            "timestamp": flow.request.timestamp_start,
                            "content_type": flow.response.headers.get("content-type") if flow.response else None
                        }
                        results.append(entry)
                    except Exception as e:
                        continue
    except Exception as e:
        print(f"[X] Failed to parse log: {e}")
        return

    with open(output_json_path, "w") as out:
        json.dump(results, out, indent=2)
