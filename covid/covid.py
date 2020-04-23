import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns
from bs4 import BeautifulSoup
import requests
from collections import Counter
import datetime as dt

from sqlalchemy import create_engine
db = create_engine('sqlite:///../../working_version/database.db')
connection = db.raw_connection()

url = "https://github.com/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_daily_reports/"
soup = BeautifulSoup(requests.get(url).text, features='lxml')
timeline_csvs = soup.select("a[href$='.csv']")
last_date = dt.datetime.strptime(timeline_csvs[-1]['href'].split("/")[-1][:-4],"%m-%d-%Y")

def update_countries(df):
    misspelled_countries = ["Taiwan","China","Russia","Bahamas","Gambia","Hong Kong","Iran","Moldova","Ireland","Taipei"]
    
    df.loc[(df['Country_Region']=="Macao SAR") | (df['Country_Region']=="Macau"),"Country_Region"] = "Macao"
    df.loc[(df['Country_Region']=="Republic of Korea") | (df['Country_Region']=="Korea, South"),"Country_Region"] = "South Korea"
    df.loc[(df['Country_Region']=="West Bank and Gaza") | (df['Country_Region'].str.contains("Palestin")),"Country_Region"] = "Palestinian Territory"
    df.loc[df['Country_Region']=="UK","Country_Region"] = "United Kingdom"
    df.loc[df['Country_Region']=="US","Country_Region"] = "United States"
    df.loc[df['Country_Region']=="Viet Nam","Country_Region"] = "Vietnam"
    df.loc[df['Country_Region']=="Burma","Country_Region"] = "Myanmar"
    df.loc[df['Country_Region']=="Cape Verde","Country_Region"] = "Cabo Verde"
    df.loc[df['Country_Region'].str.contains("Czech"),"Country_Region"] = "Czechia"
    df.loc[df['Country_Region'].str.startswith("Congo"),"Country_Region"] = "Congo"
    
    for country in range(len(misspelled_countries)):
        df.loc[df['Country_Region'].str.contains(misspelled_countries[country]),"Country_Region"] = misspelled_countries[country]
    
    return df

df = pd.DataFrame()
country_counts = Counter()
for each in range(len(timeline_csvs)):
    csv_date = timeline_csvs[each]['href'].split("/")[-1][:-4]
    time_slice = pd.read_html(url + csv_date + ".csv")[0]
    time_slice.columns = time_slice.columns.str.replace("/","_")
    time_slice = update_countries(time_slice)
    for country in time_slice['Country_Region'].unique():
        country_counts[country] += 1
    if len(time_slice.columns) != 13:
        if len(time_slice.columns) == 9:
            del time_slice['Latitude']
            del time_slice['Longitude']
        del time_slice['Unnamed: 0']
        del time_slice['Last Update']
        time_slice['Active'] = time_slice['Confirmed'] - time_slice['Deaths'] - time_slice['Recovered']
        time_slice['Date'] = dt.datetime.strptime(csv_date,"%m-%d-%Y")
    else:
        del time_slice['Unnamed: 0']
        del time_slice['Lat']
        del time_slice['Long_']
        del time_slice['Last_Update']
        del time_slice['Combined_Key']
        del time_slice['FIPS']
        del time_slice['Admin2']
        time_slice['Date'] = dt.datetime.strptime(csv_date,"%m-%d-%Y")
    df = df.append(time_slice)


# cursor = connection.cursor()

df.to_sql("covid_data",connection,if_exists='replace',index=False)
connection.close()