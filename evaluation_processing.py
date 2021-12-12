#
# This source file is part of the JASS open source project
#
# SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
#
# SPDX-License-Identifier: MIT
#

import os
import sys
from datetime import datetime
import numpy as np

import matplotlib.pyplot as plt

def timestampFor(line):
    
    try:
        return datetime.strptime(line.split()[0], '%Y-%m-%dT%H:%M:%S+0000')
    except:
        return datetime.strptime(line.split()[0], '%Y-%m-%dT%H:%M:%S+0100')
    
def duration(d1, d2):
    return (d1 - d2).seconds
    
def main():
    initalDeploymentPath = sys.argv[1]
    repeatedDeploymentPath = sys.argv[2]
    
    initalDeploymentValues = processDir(initalDeploymentPath)
    repeatedDeploymentValues = processDir(repeatedDeploymentPath)
    
    drawDefaultPlots(initalDeploymentValues, repeatedDeploymentValues)
    drawRatioPlots(initalDeploymentValues, repeatedDeploymentValues)

    
def processDir(path):
    files = os.listdir(path)
    
    searchTimes=[]
    actionsTimes=[]
    structureRetrievalTimes=[]
    startupTimes=[]
    
    for file in files:
        if os.path.isfile(os.path.join(path, file)):
            f = open(os.path.join(path, file),'r')
            foundLines=[]
        
            for line in f:
                for keyword in keywords:
                    if keyword in line:
                        foundLines.append(line)
                    
            values = processFoundLines(foundLines)
            searchTimes.append(values[0])
            actionsTimes.append(values[1])
        
            f.close()
        
            f = open(os.path.join(path, file),'r')
            specialValues = processSpecialCases(f)
            structureRetrievalTimes.append(specialValues[0])
            startupTimes.append(specialValues[1])
            f.close()
        
    return [np.mean(searchTimes), np.mean(actionsTimes), np.mean(structureRetrievalTimes), np.mean(startupTimes)]

# We have some operations (structure retrieval, startup) that are done together.
# We want to evaluate the total of each process, so we have to split it
def processSpecialCases(file):
    keywords = [
                'Cleaning up any leftover actions data',
                'System structure written to',
                'Finished deployment for',
                ]
    tuples=[]
    tuple = []
    
    foundCleaning = False
    foundStructure = False
    
    for line in file:
        if keywords[0] in line and not foundCleaning:
            tuple.append(line)
            foundCleaning = True
        if keywords[1] in line and foundCleaning:
            tuple.append(line)
            foundStructure = True
        if keywords[2] in line and foundStructure:
            tuple.append(line)
            tuples.append(tuple)
            foundCleaning = False
            foundStructure = False
            tuple = []

    structureRetrievalTime = 0
    startupTime = 0
    
    for tuple in tuples:
        structureTime = duration(timestampFor(tuple[1]), timestampFor(tuple[0]))
        startTime = duration(timestampFor(tuple[2]), timestampFor(tuple[1]))
        
        structureRetrievalTime += structureTime
        startupTime += startTime
        
    return [structureRetrievalTime, startupTime]
    
def processFoundLines(lines):
    searchTime = duration(timestampFor(lines[1]), timestampFor(lines[0]))
    actionsTime = duration(timestampFor(lines[2]), timestampFor(lines[1]))
    return (searchTime, actionsTime)
    
def drawDefaultPlots(data1, data2):
    tags = [['Initial Deployment'], ['Recurring Deployment']]
    transformedData1 = np.array(data1).astype(int)
    transformedData2 = np.array(data2).astype(int)
    
    transformedData = [transformedData1, transformedData2]
    
    print(transformedData)
    
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 10))
    
    for index, ax in enumerate([ax1, ax2]):
        currentData = transformedData[index]
        search = currentData[0]
        action = currentData[1]
        structure = currentData[2]
        startup = currentData[3]
        
        ind = [x for x, _ in enumerate(tags[index])]
    
        ax.bar(ind, startup, width=0.5, label='Startup', color='yellow', bottom=search+action+structure, align='center')
        ax.bar(ind, structure, width=0.5, label='Structure Retrieval', color='green', bottom=action+search, align='center')
        ax.bar(ind, action, width=0.5, label='Post Discovery Action', color='blue', bottom=search, align='center')
        ax.bar(ind, search, width=0.5, label='Device Search', color='cyan', align='center')
        
        ax.tick_params(
            axis='x',          # changes apply to the x-axis
            which='both',      # both major and minor ticks are affected
            bottom=False,      # ticks along the bottom edge are off
            top=False,         # ticks along the top edge are off
            labelbottom=False  # labels along the bottom edge are off
        )
        
        if index == 0:
            ax1.annotate(str(search)+" sec.",
                xy=(0.25, search),
                xycoords='data',
                va='center',
                xytext=(0.65, search+10),
                arrowprops=dict(arrowstyle='-', color='black', linestyle='dotted')
            )
            ax1.annotate(str(startup)+" sec.",
                xy=(0.25, (action+search+structure+startup)),
                xycoords='data',
                va='center',
                xytext=(0.65, (action+search+structure+startup+15)),
                arrowprops=dict(arrowstyle='-', color='black', linestyle='dotted')
            )
        else:
            ax2.annotate(str(search)+" sec.",
                xy=(0.25, search),
                xycoords='data',
                xytext=(0.65, search),
                va='center',
                arrowprops=dict(arrowstyle='-', color='black', linestyle='dotted')
            )
            ax2.annotate(str(startup)+" sec.",
                xy=(0.25, (action+search+structure+startup)),
                xycoords='data',
                xytext=(0.65, (action+search+structure+startup)),
                va='center',
                arrowprops=dict(arrowstyle='-', color='black', linestyle='dotted')
            )
        
        ax.annotate(str(action)+" sec.",
            xy=(0.25, (action+search)),
            xycoords='data',
            xytext=(0.65, (action+search)),
            fontsize=12,
            va='center',
            arrowprops=dict(arrowstyle='-', color='black', linestyle='dotted')
        )
        
        ax.annotate(str(structure)+" sec.",
            xy=(0.25, (action+search+structure)),
            xycoords='data',
            xytext=(0.65, (action+search+structure)),
            va='center',
            arrowprops=dict(arrowstyle='-', color='black', linestyle='dotted')
        )
        
        ax.set_xlim(-1,1)

    ax1.set_ylabel("Elapsed Time in Seconds", fontsize=14)
    
    ax1.set_xlabel("Initial Deployment", fontsize=14)
    ax2.set_xlabel("Recurring Deployment", fontsize=14)
    

    plt.subplots_adjust(right=0.8)
    plt.legend(loc=(1.01,0.5))

    plt.savefig('/Users/felice/Documents/master-thesis/evaluation/'+ figureName + '.pdf', transparent=True, bbox_inches='tight')
    plt.show()
    
    
def drawRatioPlots(data1, data2):
    countries = ['Initial Deployment', 'Recurring Deployment']
    transformedData = np.column_stack((data1, data2)).astype(int)
    
    fig, ax = plt.subplots(figsize=(16, 10))
    
    search = np.array(transformedData[0])
    action = np.array(transformedData[1])
    structure = np.array(transformedData[2])
    startup = np.array(transformedData[3])
    ind = [x for x, _ in enumerate(countries)]
    
    total = search + action + structure + startup
    proportion_search = np.true_divide(search, total)
    proportion_action = np.true_divide(action, total)
    proportion_structure = np.true_divide(structure, total)
    proportion_startup = np.true_divide(startup, total)

    plt.bar(ind, proportion_startup, width=0.25, label='Startup', color='yellow', bottom=proportion_search+proportion_action+proportion_structure, align='center')
    plt.bar(ind, proportion_structure, width=0.25, label='Structure Retrieval', color='green', bottom=proportion_action+proportion_search, align='center')
    plt.bar(ind, proportion_action, width=0.25, label='Post Discovery Action', color='blue', bottom=proportion_search, align='center')
    plt.bar(ind, proportion_search, width=0.25, label='Device Search', color='cyan', align='center')

    plt.subplots_adjust(right=0.75)

    plt.xticks(ind, countries, fontsize=14)
    plt.ylabel("Ratio", fontsize=14)
    plt.xlabel("Scenarios", fontsize=14)
    plt.legend(loc=(1.01,0.5))
    plt.ylim=1.0
    
    plt.savefig('/Users/felice/Documents/master-thesis/evaluation/'+ figureName+'_ratio.pdf', transparent=True, bbox_inches='tight')
    plt.show()
    

keywords = [
    'Searching for devices in the network',     # Start Device Search
    'Finished device search',                   # Finished Device Search/Start post discovery actions
    'Finished post discovery actions',           # Finished Post Discovery Actions/ start deployment
]
figureName = sys.argv[3]

main()

