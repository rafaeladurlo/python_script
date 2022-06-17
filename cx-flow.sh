#!/bin/sh                                                            
#author: rdurlo #Nova8

DownloadCxFlow () {
   version=$(curl -s -I 'https://github.com/checkmarx-ltd/cx-flow/releases/latest' | grep -Eo "(http|https)://[github.com][a-zA-Z0-9./?=_%:-]*" | grep -Eo "[0-9].[0-9].[0-9]*")
   echo 'CxFlow latest release version: '$version
   curl -s 'https://github.com/checkmarx-ltd/cx-flow/releases/download/'$version'/cx-flow-'$version'.jar' -o 'cx-flow-'$version'.jar'
}

DownloadCxFlow