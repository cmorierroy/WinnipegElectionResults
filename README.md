# WinnipegElectionResults

I conceived and designed this app for my final project in the Udacity iOS Developer course. <br>
It is an attempt at making information about Winnipeg's municipal elections very accessible to the public, removing the need to dig through a government website and to put the data in a spreadsheet yourself. <br>

### Current features:
<li>Records of every general and by-election going back to 1964.</li>
<li>Pie/Bar(can be switched in Preferences) charts for final election results by ward.</li>
<li>The ability to favorite an election result for easy viewing later on.</li>
<li>The ability to share an election result.</li>
<li>The ability to browse data without an internet connection if the data was previously downloaded.

### Future features:
<li>Separation of ballot question results from wards — 2018 Portage and Main is the only current ballot question. </li>
<li>Separation of school division results from wards.</li>
<li>Clear displayal of an election's winner (as opposed to having to read the chart to find out).
<li>A Councillor/School trustee detailed description view.</li>

## Project Dependencies
All dependencies are installed with cocoapods and contained in the podfile. <br>
*Charts*: For presenting scraped data. <br>

If you are attempting to build this in Xcode, build it from the WinnipegElectionResults.xworkspace file.

## Intended User Experience:
The user is presented with a home page, on which a table view will list the election types available to browse after it downloads and saves them through a network request.<br> As of December 2020, these are "General elections" and "By-elections". <br>
<img width="382" alt="Screen Shot 2020-12-22 at 12 14 57 PM" src="https://user-images.githubusercontent.com/16982565/102924619-8f2f0900-4457-11eb-82e1-1c8b5cf72450.png"><br>

If the user selects an election type, they are brought to a filter view with a table where they can browse avaiable dates or areas (togglable). <br>
<img width="380" alt="Screen Shot 2020-12-22 at 12 15 32 PM" src="https://user-images.githubusercontent.com/16982565/102926471-a7ecee00-445a-11eb-9b76-2d08096f33f7.png"><br>

If the user further selects a date/area, they are brought to a collection view that displays a small version of election result charts which can be selected. <br>
<img width="373" alt="Screen Shot 2020-12-22 at 12 15 40 PM" src="https://user-images.githubusercontent.com/16982565/102926597-ebdff300-445a-11eb-86be-05d0bb83b460.png">

Upon selection, the user is brought to a detail view where they can visualize the result.
<img width="375" alt="Screen Shot 2020-12-22 at 12 15 59 PM" src="https://user-images.githubusercontent.com/16982565/102926661-0914c180-445b-11eb-8382-6a49f7132797.png"><br>

The user can favorite the result by clicking the favorites button, and this will be shown with a filled star.<br>
<img width="375" alt="Screen Shot 2020-12-22 at 12 15 59 PM" src="https://user-images.githubusercontent.com/16982565/102927887-6f024880-445d-11eb-87af-8ae2713955eb.png"><br>

The user can also share the result by clicking on the share button.<br>
<img width="378" alt="Screen Shot 2020-12-22 at 12 16 10 PM" src="https://user-images.githubusercontent.com/16982565/102927950-8a6d5380-445d-11eb-87fd-70b8942a2233.png"><br>

At the bottom of each view, the user has the option to select the Favorites tab, where they can visualize what results they've favorited:<br>
<img width="380" alt="Screen Shot 2020-12-22 at 12 15 14 PM" src="https://user-images.githubusercontent.com/16982565/102926504-baffbe00-445a-11eb-862f-1ed2bfefbceb.png"><br>

Alternatively, they can select the Preferences tab, where the only option is currently to toggle viewing graphs as a bar chart or as a pie chart.<br>
<img width="378" alt="Screen Shot 2020-12-22 at 12 15 22 PM" src="https://user-images.githubusercontent.com/16982565/102927683-087d2a80-445d-11eb-9465-552e32987ce4.png"><br>

