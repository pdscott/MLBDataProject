# Author: Preston Scott
# This scipt scrapes scheduling data from baseball-reference.com and assembles it into a matrix format.
# To use this script just change the year of interest in the url below
# Be aware the some teams changed names over the course of time so some items in the lookup table may fail
#



from urllib.request import urlopen
import bs4 #this is beautiful soup
import numpy as np
import scipy as sp
import pandas as pd

columns=['BAL','BOS','CHW','CLE','DET','HOU','KCR','LAA','MIN','NYY','OAK','SEA','TBR','TEX','TOR','ARI','ATL','CHC','CIN','COL','LAD','MIA','MIL','NYM','PHI','PIT','SDP','SFG','STL','WSN']
index= ['BAL','BOS','CHW','CLE','DET','HOU','KCR','LAA','MIN','NYY','OAK','SEA','TBR','TEX','TOR','ARI','ATL','CHC','CIN','COL','LAD','MIA','MIL','NYM','PHI','PIT','SDP','SFG','STL','WSN']

newSched = pd.DataFrame(index=index, columns=columns)
newSched = newSched.fillna(0)

teamIndex = 0
for team in columns:
    url = 'http://www.baseball-reference.com/teams/'
    print('Parsing',team)
    url += team
    url += '/2014-schedule-scores.shtml#team_schedule::none'
    source = urlopen(url).read()
    soup = bs4.BeautifulSoup(source, "lxml")
    table = soup.find(id="team_schedule")
    rows = table.find_all('tr')
    for i in range(1,51):
        row = rows[i]
        cols = row.find_all('td')
        team = cols[6].a.text
        newSched.iloc[teamIndex][team] += 1
    for i in range(52,102):
        row = rows[i]
        cols = row.find_all('td')
        team = cols[6].a.text
        newSched.iloc[teamIndex][team] += 1
    for i in range(103,153):
        row = rows[i]
        cols = row.find_all('td')
        team = cols[6].a.text
        newSched.iloc[teamIndex][team] += 1
    for i in range(154,166):
        row = rows[i]
        cols = row.find_all('td')
        if cols != []:
            team = cols[6].a.text
            newSched.iloc[teamIndex][team] += 1
    teamIndex += 1

#print(newSched)
newSched.to_csv('2014sched.csv', sep=',')

