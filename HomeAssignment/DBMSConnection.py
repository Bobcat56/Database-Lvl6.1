import pyodbc
import pandas
import sys
import json

'''
	            ----	QUESTION 6		----
Create a Python application with the following requirements:
'''

# c) A global variable called conn where the database connection is stored.
global conn

'''
a) A function called createConnection that accepts a server name, and a database name. The 
   function should establish a connection to the DBMS and return the connection.
'''


def createConnection(serverName, databaseName):
    global conn

    conn = pyodbc.connect(
        'DRIVER={SQL Server};'
        f'SERVER={serverName};'
        f'DATABASE={databaseName};'
        'Trusted_Connection=yes;'
    )
    return conn


'''
b) A function called closeConnection that accepts a database connection as a parameter, it closes 
   the connection, and exits the program
'''


def closeConnection(connection):
    connection.close()
    sys.exit(0)


'''
d) A function called loadData that accepts a file path. This function must have the following 
functionality:
'''


# noinspection PyBroadException
def loadData(filePath):
    global conn

    try:
        # a. Loads the JSON data from the given file (parameter).
        #    Hint: you can use json package.
        with open(filePath + '.json', "r") as file:
            jsonData = json.load(file)
            jsonString = json.dumps(jsonData)

        # b. Insert the JSON data into the loading.json_data table.
        #    Hint: the JSON data must be converted to string.
        cursor = conn.cursor()

        cursor.execute('INSERT INTO loading.JsonData (json_Data, date_Loaded) VALUES (' + jsonString + ', GETDATE());')
        cursor.commit()
    #   c. You must use error handling in this function taking care of 3 types of errors as follows.
    #      For each case, make sure to print an appropriate message.
    #   i. An error that is returned from pyodbc.
    except pyodbc.DatabaseError as e:
        print(f'Error: {e}\n')
    #   ii. An error that is returns if the file is not found.
    except FileNotFoundError as e:
        print("Error: File not found"
              f"{e}\n")
    #   iii. A generic error.
    except Exception:
        print("Error: An unknown error has occurred\n")


'''
e) A function called getRatings that accepts a decimal as a parameter. The function must have 
the following functionality:
'''


# noinspection PyBroadException
def getRatings(decimal):
    global conn

    try:
        # a. It must call the function main.getProductsRating.
        cursor = conn.cursor()
        cursor.execute(f'SELECT main.getProductsRating({decimal})')

        # b. It must print the result of the function as a table.
        # Hint: you can use pandas package to read JSON data.
        rowData = pandas.DataFrame(cursor.fetchall())

        for item in rowData.items():
            result = item[1].values[0].__str__()
            jsonPart1 = result.split("[")[1]
            jsonPart2 = jsonPart1.split("]")[0]

            dict = json.loads(jsonPart2)
            df = pandas.DataFrame(dict, index=[0])
            print(df)

    # c. You must use error handling in this function taking care of 2 types of errors as follows.
    # For each case, make sure to print an appropriate message.
    # i. An error that is returned from pyodbc.
    except pyodbc.Error as e:
        print(f'Error: {e}\n')
    #   ii. A generic error.
    except Exception as e:
        print('Error: An unknown error has occurred'
              f'\n{e}\n')


'''
f) A function called showMenu that displays the following options. The menu must keep 
   appearing until the users chooses to exit.
'''


def showMenu():
    createConnection(serverName, databaseName)
    print('\nPlease choose one of the following options\n')
    print('==============Menu==============')
    print('1.) Load Data')
    print('2.) Get Products by Rating')
    print('3.) Exit')
    print('================================')
    choice = input('>>')

    #    a. Option 1: Load Data
    #    This will ask the user for a file location, and then call the function loadData.
    if choice == '1':
        fileLocation = input('Please enter the file location: ')
        loadData(fileLocation)
    #    b. Option 2: Get Products by Rating
    #    This will ask for a rating from 1 to 5, and then call getRatings function.
    elif choice == '2':
        rating = input('Enter your desired rating (1 to 5): ')
        getRatings(rating)
    #    c. Option 3: Exit
    #   This will call closeConnection.
    elif choice == '3':
        print('\nExiting ...')
        closeConnection(conn)
    else:
        print('Invalid option.\n')


'''
*******************************************************************************************
'''

# Instantiating server and database from user inputs
# serverName = input('Please enter the server being used: ')
# databaseName = input('Please enter the database being used: ')

# Hardcoded server and database inputs
serverName = 'DESKTOP-DQFU4AL\SQLEXPRESS'
databaseName = 'a3products'

while True:
    showMenu()

# noinspection PyUnreachableCode
'''
*******************************************************************************************
'''
