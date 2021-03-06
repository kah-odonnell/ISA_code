from django.shortcuts import render

# response
from django.shortcuts import render, render_to_response
from django.http import HttpResponse, HttpResponseRedirect, Http404, JsonResponse
from django.core.urlresolvers import reverse

# authenticate
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from django.contrib.auth import login as auth_login
from django.contrib.auth.decorators import login_required
from django.contrib.auth import hashers

import urllib.request
from urllib.error import HTTPError 

#these are not front faceing POSTs so we don't need csrf tokens
from django.views.decorators.csrf import csrf_exempt

import json

def index(request):
	print("index")

def get_event_page_json(request, event_id):
	try:
		with urllib.request.urlopen("http://models_host:80/api/v1/get/event/"+event_id+"/") as url:
			str_response = url.read().decode('utf-8') 
			event_page_json = json.loads(str_response) 
	except HTTPError:
		return _error_response(request, 'unable to get http response from models api')
	return JsonResponse(event_page_json)	
