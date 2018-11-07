import jenkinsapi
from jenkinsapi.jenkins import Jenkins

import argparse
import json
import requests
from requests.auth import HTTPDigestAuth, HTTPBasicAuth

parser = argparse.ArgumentParser()
parser.add_argument("job")
parser.add_argument("build")
args = parser.parse_args()

JENKINS_URL = 'http://localhost:8080'
JENKINS_USER = 'User'
JENKINS_PASS = 'Pass'
SNC_URL = 'https://Instance.service-now.com'
SNC_USER = 'User'
SNC_PASS = 'Pass'

def publish_results():

    # If your Jenkins server has not authentication set you might want to change the following line
	#J = Jenkins(JENKINS_URL)
	J = Jenkins(JENKINS_URL, username=JENKINS_USER, password=JENKINS_PASS)
	print (">>>>job=%s" % args.job)
	print (">>>>build=%s" % args.build)
    
	job = J[args.job]
	build = job.get_build(int(args.build))
    
	output = {}
    
	status = build.get_status()
	console = build.get_console()
	#revision = build.get_revision()
	duration = build.get_duration() # Need to cook this
	url = build.baseurl
    
    
	print (">>>>>status=%s" % status)
	print (">>>>>console_length=%s" % len(console))
	#print (">>>>>revision=%s" % revision)
	print (">>>>>duration=%s" % duration)
    
	output['job'] = args.job
	output['build_number'] = args.build
	output['status'] = status
	output['console'] = console
	#output['revision'] = revision
	output['duration'] = str(duration)
	output['url'] = url
    
	resultset = build.get_resultset()  
    
	print (">>>>>passCount=%s" % resultset._data['passCount'])  
	print (">>>>>failCount=%s" % resultset._data['failCount'])
	print (">>>>>skipCount=%s" % resultset._data['skipCount'])
    
	output['pass_count'] = resultset._data['passCount']
	output['fail_count'] = resultset._data['failCount']
	output['skip_count'] = resultset._data['skipCount']
    
	results = resultset.items()
    
	output['results'] = []
    
	count = 1
	for i in results:
		d = {}
		print (">>>>>>>>>>>>>item=%s name=%s" % (count, i[0]))
		d['name'] = i[0]
        
		print (">>>>>>>>>>>>>status=%s" % i[1].status)
		d['status'] = i[1].status
        
		print (">>>>>>>>>>>>>error_details=%s" % i[1].errorDetails)
		d['error_details'] = i[1].errorDetails
        
		print (">>>>>>>>>>>>>error_stackTrace=%s" % i[1].errorStackTrace)
		d['error_stack_trace'] = i[1].errorStackTrace
        
		print (">>>>>>>>>>>>>test_case=%s" % i[1].className)
		d['test_case'] = i[1].className
        
		output['results'].append(d)
		count += 1
    
    
	_json = json.dumps(output, sort_keys=True)
    
	print ("JSON OUTPUT=%s" % _json)
    
	print ("Sending results to ServiceNow")
	url = SNC_URL + "/api/snc/jenkinsimport/results"
	requests.post(url=url, data=_json, auth=HTTPBasicAuth(SNC_USER, SNC_PASS))
    
if '__main__' == __name__:
	publish_results()
