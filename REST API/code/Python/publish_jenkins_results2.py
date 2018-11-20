import jenkinsapi
from jenkinsapi.jenkins import Jenkins

import argparse
import json
import requests
from requests.auth import HTTPDigestAuth, HTTPBasicAuth

parser = argparse.ArgumentParser()
parser.add_argument("job")
parser.add_argument("build")
parser.add_argument("request_id")
args = parser.parse_args()

JENKINS_URL = 'http://10.211.217.25:8080'
JENKINS_USER = 'Admin'
JENKINS_PASS = 'Znrop547677'
SNC_URL = 'https://dev52858.service-now.com'
SNC_USER = 'simon.nguyen4_priv'
SNC_PASS = 'Nguy@n547677'

def publish_results():

    # If your Jenkins server has not authentication set you might want to change the following line
	#J = Jenkins(JENKINS_URL)
	J = Jenkins(JENKINS_URL, username=JENKINS_USER, password=JENKINS_PASS)
	print (">>>>job=%s" % args.job)
	print (">>>>build=%s" % args.build)
	print (">>>>request_id=%s" % args.request_id)
    
	job = J[args.job]
	build = job.get_build(int(args.build))	
    
	output = {}
    
	status = build.get_status()
	console = build.get_console()
	#revision = build.get_revision()
	duration = build.get_duration() # Need to cook this
	url = build.baseurl
	causes = build.get_causes()
    
    
	print (">>>>>status=%s" % status)
	print (">>>>>console_length=%s" % len(console))
	#print (">>>>>revision=%s" % revision)
	print (">>>>>causes=%s" % causes)
	print (">>>>>duration=%s" % duration)
    
	output['job'] = args.job
	output['build_number'] = args.build
	output['request_id'] = args.request_id
	output['status'] = status
	output['console'] = console
	#output['revision'] = revision
	output['duration'] = str(duration)
	output['url'] = url
	#output['causes'] = causes
    
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
		
		#print (">>>>>>>>>>>>>causes=%s" % i[1].causes)
		#d['causes'] = i[1].className
        
		output['results'].append(d)
		count += 1
    
    
	_json = json.dumps(output, sort_keys=True)
    
	print ("JSON OUTPUT=%s" % _json)
    
	print ("Sending results to ServiceNow")
	url = SNC_URL + "/api/snc/jenkinsimport/results"
	#requests.post(url=url, data=_json, auth=HTTPBasicAuth(SNC_USER, SNC_PASS))
    
if '__main__' == __name__:
	publish_results()
