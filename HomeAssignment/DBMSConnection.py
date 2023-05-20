import pyodbc
import sys
import json

'''
	    ----	QUESTION 6		----
Create a Python application with the following requirements:
'''
#c) A global variable called conn where the database connection is stored.
global conn

'''
a) A function called createConnection that accepts a server name, and a database name. The 
   function should establish a connection to the DBMS and return the connection.
'''
def createConnection(serverName, databaseName):
    global conn
    conn = pyodbc.connect('Driver = {SQL Server};'
    'Server = %s;'
    'Database = %s;'
    'Trusted_Connection=yes;'%(serverName, databaseName))

    print ("Connection with Database " + conn + " created")
    return conn

'''
b) A function called closeConnection that accepts a database connection as a parameter, it closes 
   the connection, and exits the program
'''
def closeConnection(connection):
    connection.close()
    sys.exit

'''
d) A function called loadData that accepts a file path. This function must have the following 
functionality:
'''
def loadData(filePath):
    global conn
#   c. You must use error handling in this function taking care of 3 types of errors as follows. 
#   For each case, make sure to print an appropriate message.
    try:
#       a. Loads the JSON data from the given file (parameter).
#       Hint: you can use json package.
        with open (filePath, "r") as file:
            jsonData = json.load(file)
        jsonString = json.dumps(filePath)

#       b. Insert the JSON data into the loading.json_data table. 
#       Hint: the JSON data must be converted to string.
        cursor = conn.cursor()
        cursor.execute(f'INSERT INTO loading.JsonData'
                        '(json_Data, date_Loaded)'
                        'VALUES {jsonString}, GETDATE())')
        cursor.commit()
#   i. An error that is returned from pyodbc.
    except pyodbc.DatabaseError as e:
        print ('Error: {e}}')
#   ii. An error that is returns if the file is not found.
    except FileNotFoundError:
        print ("Error: File not found")
#   iii. A generic error.
    except:
        print ("Error: An unkown error has occurred")


'''
e) A function called getRatings that accepts a decimal as a parameter. The function must have 
the following functionality:
'''
def getRatings(decimal):
    global conn
#   c. You must use error handling in this function taking care of 2 types of errors as follows. 
#   For each case, make sure to print an appropriate message.
    try:
#       a. It must call the function main.getProductsRating.
        cursor = conn.cursor()
        cursor.execute("EXEC main.getProductsRating({decimal})")
        rows = cursor.fetchall()

#   b. It must print the result of the function as a table. 
#   Hint: you can use pandas package to read JSON data.

#   i. An error that is returned from pyodbc.
    except pyodbc.Error as e:
        print(f"Error: {e}")
#   ii. A generic error.
    except:
        print("Error: An unkown error has occurred")


'''
f) A function called showMenu that displays the following options. The menu must keep 
   appearing until the users chooses to exit.
'''
def showMenu():
    while True:
        choice = input('Please choose one fo the following options')

        print ('==============Menu==============')
        print ('1.) Load Data')
        print ('2.) Get Products by Rating') 
        print ('3.) Exit')
        print ('================================')

#       a. Option 1: Load Data 
#       This will ask the user for a file location, and then call the function loadData.
        if choice == '1':
            fileLocation = input("Please enter the file location: ")
            loadData(fileLocation)
#       b. Option 2: Get Products by Rating 
#       This will ask for a rating from 1 to 5, and then call getRatings function.
        elif choice == '2':
            rating = input("Enter your desired rating (1 to 5): ")
            getRatings(rating)
#       c. Option 3: Exit 
#       This will call closeConnection.
        elif choice == '3':
            print ('Exitting ...')
            closeConnection()
        else:
            print("Invalid option. Please choose from the options provided.")

showMenu()