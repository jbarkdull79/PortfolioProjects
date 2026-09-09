using EmployeeManagement.Models;
using System.ComponentModel.Design;

List<Employee> employees = new List<Employee>();

bool running = true;

while (running)
{


    Console.WriteLine("========================================");
    Console.WriteLine("        Employee Management System");
    Console.WriteLine("========================================");

    Console.WriteLine("1. Add Employee");
    Console.WriteLine("2. View Employees");
    Console.WriteLine("3. Search Employee");
    Console.WriteLine("4. Calculate Salary");
    Console.WriteLine("5. Remove Employee");
    Console.WriteLine("6. Exit");

    Console.WriteLine();
    Console.Write("Choose Option: ");

    string choice = Console.ReadLine() ?? "";

    if (choice == "1")
    {

        Console.Write("Enter Employee ID: ");

        if (!int.TryParse(Console.ReadLine(), out int employeeId))
        {
            Console.WriteLine("Invalid Employee ID. Please enter a whole number.");
            continue;
        }
        if (employees.Any(e => e.EmployeeId == employeeId))
        {
            Console.WriteLine("An employee with that ID already exists.");
            continue;
        }
        Console.Write("Enter Employee Name: ");
        string name = Console.ReadLine() ?? "";

        Console.Write("Enter Department: ");
        string department = Console.ReadLine() ?? "";

        Console.Write("Enter Salary: ");

        if (!decimal.TryParse(Console.ReadLine(), out decimal salary))
        {
            Console.WriteLine("Invalid salary. Please enter a number.");
            continue;
        }

        Employee employee = new Employee(employeeId, name, department, salary);

        employees.Add(employee);

        Console.WriteLine("Employee added successfully!");
    }
    else if (choice == "2")
    {
        Console.WriteLine("Employee List:");

        foreach (Employee employee in employees)
        {
            Console.WriteLine(
                $"ID: {employee.EmployeeId}," +
                $" Name: {employee.Name}," +
                $"Department: {employee.Department}, " +
                $"Salary: {employee.Salary}"
                );
        }
    }
    else if (choice == "3")
    {
        Console.Write("Enter Employee ID to search: ");

        if (!int.TryParse(Console.ReadLine(), out int searchId))
        {
            Console.WriteLine("Invalid Employee ID. Please enter a whole number.");
            continue;
        }

        Employee? foundEmployee = employees.FirstOrDefault(e => e.EmployeeId == searchId);

        if (foundEmployee != null)
        {
            Console.WriteLine(
                $"ID: {foundEmployee.EmployeeId}," + 
                $"Name: {foundEmployee.Name}, " +
                $"Department: {foundEmployee.Department},"+ 
                $"Salary: {foundEmployee.Salary:C}"
                );
        }
        else
        {
            Console.WriteLine("Employee not found.");
        }
    }
    else if (choice == "4")
    {
        Console.Write("Enter Employee ID to calculate salary: ");

        if (!int.TryParse(Console.ReadLine(), out int salaryId))
        {
            Console.WriteLine("Invalid Employee ID. Please enter a whole number.");
            continue;
        }

        Employee? salaryEmployee =
       employees.FirstOrDefault(e => e.EmployeeId == salaryId);

        if (salaryEmployee != null)
        {
            decimal monthlySalary = salaryEmployee.Salary / 12;

            Console.WriteLine($"Employee: {salaryEmployee.Name}");
            Console.WriteLine($"Annual Salary: {salaryEmployee.Salary:C}");
            Console.WriteLine($"Monthly Salary: {monthlySalary:C}");
        }
        else
        {
            Console.WriteLine("Employee not found.");
        }
    }
    else if (choice == "5")
    {
        Console.Write("Enter Employee ID to remove: ");

        if (!int.TryParse(Console.ReadLine(), out int removeId))
        {
            Console.WriteLine("Invalid Employee ID. Please enter a whole number.");
            continue;
        }

        Employee? employeeToRemove =
            employees.FirstOrDefault(e => e.EmployeeId == removeId);

        if (employeeToRemove != null)
        {
            employees.Remove(employeeToRemove);

            Console.WriteLine("Employee removed successfully.");
        }
        else
        {
            Console.WriteLine("Employee not found.");
        }
    }
    else if (choice == "6")
    {
        Console.Write("Enter Employee ID to update: ");

        if (!int.TryParse(Console.ReadLine(), out int updateId))
        {
            Console.WriteLine("Invalid Employee ID. Please enter a whole number.");
            continue;
        }

        Employee? employeeToUpdate =
            employees.FirstOrDefault(e => e.EmployeeId == updateId);

        if (employeeToUpdate != null)
        {
            Console.Write("Enter New Employee Name: ");
            string newName = Console.ReadLine() ?? "";

            Console.Write("Enter New Department: ");
            string newDepartment = Console.ReadLine() ?? "";

            Console.Write("Enter New Salary: ");

            if (!decimal.TryParse(Console.ReadLine(), out decimal newSalary))
            {
                Console.WriteLine("Invalid salary. Please enter a number.");
                continue;
            }

            employeeToUpdate.Name = newName;
            employeeToUpdate.Department = newDepartment;
            employeeToUpdate.Salary = newSalary;

            Console.WriteLine("Employee updated successfully!");
        }
        else
        {
            Console.WriteLine("Employee not found.");
        }
    }
    else if (choice == "7")
    {
        running = false;
        Console.WriteLine("Exiting Employee Management System...");
    }
    else
    {
        Console.WriteLine("Invalid option. Please choose a number from 1 to 7.");
    }
}








