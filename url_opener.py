import os
import webbrowser
import subprocess


us_state_abbrev = {
    #this is because people input state's names later
    #the website needs abbreviations
    #this dictionary converts state names to abbrevations
    #often referred to a key/value pair
    'alabama': 'AL',
    'alaska': 'AK',
    'arizona': 'AZ',
    'arkansas': 'AR',
    'california': 'CA',
    'colorado': 'CO',
    'connecticut': 'CT',
    'delaware': 'DE',
    'florida': 'FL',
    'georgia': 'GA',
    'hawaii': 'HI',
    'idaho': 'ID',
    'illinois': 'IL',
    'indiana': 'IN',
    'iowa': 'IA',
    'kansas': 'KS',
    'kentucky': 'KY',
    'louisiana': 'LA',
    'maine': 'ME',
    'maryland': 'MD',
    'massachusetts': 'MA',
    'michigan': 'MI',
    'minnesota': 'MN',
    'mississippi': 'MS',
    'missouri': 'MO',
    'montana': 'MT',
    'nebraska': 'NE',
    'nevada': 'NV',
    'new hampshire': 'NH',
    'new jersey': 'NJ',
    'new mexico': 'NM',
    'new york': 'NY',
    'north carolina': 'NC',
    'north dakota': 'ND',
    'ohio': 'OH',
    'oklahoma': 'OK',
    'oregon': 'OR',
    'pennsylvania': 'PA',
    'rhode island': 'RI',
    'south carolina': 'SC',
    'south dakota': 'SD',
    'tennessee': 'TN',
    'texas': 'TX',
    'utah': 'UT',
    'vermont': 'VT',
    'virginia': 'VA',
    'washington': 'WA',
    'west virginia': 'WV',
    'wisconsin': 'WI',
    'wyoming': 'WY',
}


def urlopen():
    while True:
        deal_name = input("Input deal name: ").lower()
        # user input

        if deal_name != "":
            urls = ['https://mail.google.com/mail/u/0/#search/'+"subject: "+str.replace(deal_name," ","+"),
                    # USED FOR SEARCHING IN GMAIL, SALESFORCE, COPPER, AND DROPBOX

                    'https://app.prosperworks.com/companies/174779/app?p=db#/search-results/all/%257B%2522phrase%\
                    2522%253A%2522'+str.replace(deal_name, " ", "%2520")+'%2522%257D',

                    # Copper
                    ' https://na88.salesforce.com/_ui/search/ui/UnifiedSearchResults?searchType=2&sen=001&sen=00Q&\
                    sen=a1c&sen=003&sen=005&sen=006&str='+str.replace(deal_name, " ", "+"),

                    # SALESFORCE
                    # 'https://www.truthfinder.com/dashboard/search/person/?first='+first_name+'&last='+last_name+'&\
                    # city='+str.replace(city," ","%20")+'&state='+us_state_abbrev.get(state)

                    # TRUTHFINDER
                    ]
            subprocess.Popen(
                'explorer "search-ms:displayname=Search%20Results%20in%20Dropbox%20(Biz%20cap)&crumb=System.Generic.String%3A(' + str.replace(deal_name, " ", "%20")+ ')&crumb=location:C%3A%5CUsers%5CUser%5CDropbox%20(Biz%20cap)"')

            for each in urls:
                # this will open each url
                # it cycles through the urls[] array
                webbrowser.open(each)
            continue
        elif deal_name == "":
            break


urlopen()

