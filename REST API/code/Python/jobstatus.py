import argparse
import requests


class JobStatus:
    def __init__(self, url, job):
        self.job=job
        self.url=url

    def get_overview(self):
        full_url = args.url +"job/" + args.job +"/api/json?pretty=true"

        res = requests.get(full_url)
        if res.status_code == 200:
            overview = res.json()
            return overview
        return {}
    def last_build_successful(self, overview):
        success = False
        if overview["lastCompletedBuild"]["number"] == overview["lastSuccessfulBuild"]["number"]:
            success = True
        return success
    def is_success(self):
        overview = self.get_overview()
        success = self.last_build_successful(overview)
        return success

if(__name__=="__main__"):
    parser = argparse.ArgumentParser(description="Job status monitor")

    parser.add_argument("-url", help="url of Jenkins box including trailing slash")
    parser.add_argument("-job", help="job name in Jenkins")

    args = parser.parse_args()

    status1 = JobStatus(args.url, args.job)
    print ("Success: " + str(status1))