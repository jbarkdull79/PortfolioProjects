using System;
using System.Collections.Generic;
using System.Text;

namespace EmployeeManagement.Models
{
    internal class Employee
    {
        public int EmployeeId { get; set; }

        public string Name { get; set; }

        public string Department { get; set; }

        public decimal Salary { get; set; }

        public Employee(int employeeId, string name, string department, decimal salary)
        {
            EmployeeId = employeeId;
            Name = name;
            Department = department;
            Salary = salary;

        }
    }
}
