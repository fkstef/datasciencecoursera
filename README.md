# getting data - project

## files download
the script will start by downloading the required zip file with the dataset and unzip it in the working directory

## data loading into memory
once the files are available on the disk, the script will load all data sets into memory:

* mapping tables: all "global" tables such as activity labels or features will be loaded first in their own variable
* merge training and test data: then all files from subfolders ("train","test") will be loaded. A pair of files will be loaded together by the function ''readAndMerge'' which creates a single dataframe from both training and testing data using the ''rbind'' function

## expand data set with descriptive labels
when all data is loaded in memory, some descriptive data is added to the ''x'' dataset to make up the final ''data'' frame.

* the columns of the main data set will have their appropriate name given from the "feature" file
* the activity and subject columns will then be added to the dataset
* the activity code will be expanded to its label from the "activity labels" file. This is done using the ''merge'' function

## restrict data to only wanted columns
Once all additional descriptive information is added, the script will restrict the data to only those columns that contain a mean or standard deviation. This is done by finding from the column names those that relate to a captured data (prefix 't') and end with either "mean" or "std".

After this step, columns are reordered for a clean display: activity name and subject id first, then the rest of the captured data

## summarise the data (step 5 in the exercise)
Data is summarised using the ''dplyr'' library. The sequence of steps is as follows:

* use the dataframe called ''data'' as source data
* group all rows by activity, then subject id
* use the ''summarise_each'' function to apply the ''mean'' function to each group and get the expected result

## save result to a file
Finally, the result is written to a text file according to the instructions in the project details
