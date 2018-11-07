#!/usr/bin/env python

import re
import argparse
import requests

jenkins_url = "https://localhost:8080"

# Add new jobs here:
jobs = {
    "my_job": "/folder/subfolder/jobname"
}

def call_jenkins(path):
    return requests.get("{0}/{1}".format(jenkins_url, path), verify=False)

def build_jenkins_path(job):
	paths = job.split("/")
    path = "".join([p + "/job/" for p in paths])
    return re.sub("/job/$", "",path)

def get_job_console_output(job):
    path = build_jenkins_path(job)
    url = "{0}{1}".format(path, "/lastBuild/consoleText")
    return call_jenkins(url)

if __name__ == '__main__':
    # Example: python jenkinsJobConsoleOutput.py -j my_job
    parser = argparse.ArgumentParser()
    parser.add_argument('-j', dest="job", help="Choose job to get console logs from")
    args = parser.parse_args()

    job_path = jobs.get(args.job)
    result = get_job_console_output(job_path).text
    print(result)