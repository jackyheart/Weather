**App Architecture**

![Alt text](documentation/app_architecture.png?raw=true "App Architecture")

**Additional information**

1. On Use Case 1, it's unclear where data will come from<br />
   For this, I took the liberty of only filtering the stored data,<br />
   as it will not be feasible (not recommended) to keep hittng the api everytime User enters a search string
   
2. On Use Case 4 & 5<br />
   It doesn't mention how long the cache data should be kept, whether by time elapsed or by number of items.<br />
   In real app, it should be determined on how the local cache should be cleared.<br />
   In this exercise, I've implemented a variable to determine how many items the local cache should store,<br />
   and delete least recently visited items

**Code Coverage**
