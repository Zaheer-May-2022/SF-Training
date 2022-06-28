public class Employee {
    string Employeename;
    Integer EmployeeNo;
    Public Employee() {
        EmployeeName = 'Zaheer Khan';
        EmployeeNo = 1015;
    }
    public void Show() {
        System.debug('Employee Name is' + EmployeeName);
        System.debug('Employee No is' + EmployeeNo);
    }
}