#!/bin/sh
#


pod spec lint --verbose XSToast.podspec

pod trunk push XSToast.podspec --allow-warnings --verbose --use-libraries
# pod repo push master XSNetwork.podspec --allow-warnings