import csv

path = "data\paper_scenarios2\moralchoice_low_ambiguity.csv"
path2 = "data\paper_scenarios2\moralchoice_2low_ambiguity.csv"
sum = 0
# Open the CSV file for reading
with open(path, 'r') as file:
    reader = csv.reader(file)
    # Skip the header
    header = next(reader)
    
    # Open a new CSV file for writing
    with open(path2, 'w', newline='') as new_file:
        writer = csv.writer(new_file)
        writer.writerow(header)
        
        # Iterate through each row in the original file
        for row in reader:
            x = ""
            while x not in ["y", "n"]:
            # Add the new element to each row
                x =  input(f"""Situation : {row[4]}
                        Option 1 : {row[5]}
                        Option 2 : {row[6]}
                        Violation of dignity ? (y/n) : """)
                if x == "y":
                    x = "Yes"
                elif x == "n":
                    x = "No"
            new_row = row + ["No"] + [x]  # Add the new element to the row
            
            # Write the modified row to the new file
            writer.writerow(new_row)
            sum += 1
            if sum % 50 == 0:
                print(f"{sum} scenarios done, {687 - sum} scenarios remaining")