import 'dart:html';
import 'package:bdd_lib/bdd_lib.dart';

Company company;

DivElement console = querySelector("#console");
DivElement employees_list = querySelector("#employees-list");
InputElement new_user_field = querySelector("#new-user");
DivElement employee_name = querySelector("#employee-name");
InputElement new_proposal_field = querySelector("#new-proposal");
UListElement proposals_list = querySelector("#proposals-list");
DivElement employee_details = querySelector("#employee-details");

TableElement choices = querySelector("#choices");

void main() {

  new_user_field
      ..onKeyPress.listen((KeyboardEvent e) {
        if (e.keyCode == KeyCode.ENTER) {
          var name = new_user_field.value.trim();
          if (name != '') {
            Employee employee = new Employee(name);
            company.addEmployee(employee);
          }
          updateEmployeeList();
          new_user_field.value = "";
        }
      })
      ..onFocus.listen((Event e) {
        hideEmployeeDetails();
      });

  new_proposal_field.onKeyPress.listen((KeyboardEvent e) {
    if (e.keyCode == KeyCode.ENTER) {
      var proposal = new_proposal_field.value.trim();
      if (proposal != '') {
        Employee employee = company.findByName(employee_name.text);
        employee.addProposal(proposal);

        var prop = new LIElement();
        prop.text = proposal;
        proposals_list.children.add(prop);

        updateChoices();
      }
      new_proposal_field.value = "";
    }
  });


  init();  
}

void init() {
  company = new Company("SonarSource");
  company.init();

  hideEmployeeDetails();
  updateEmployeeList();
  updateChoices();
}

void updateEmployeeList() {
  if (employees_list.children.length > 0) {
    employees_list.children[0].remove();
  }

  UListElement list = new UListElement();
  employees_list.append(list);
  company.getEmployees().forEach((e) {
    var emp = new LIElement()..onClick.listen(displayEmployee);
    emp.text = e.getName();
    list.children.add(emp);
  });
}

void showEmployeeDetails() {
  employee_details.setAttribute("style", "visibility: visible");
}

void hideEmployeeDetails() {
  employee_details.setAttribute("style", "visibility: hidden");
}

void displayEmployee(Event e) {
  proposals_list.remove();
  proposals_list = new UListElement();
  employee_details.append(proposals_list);

  Element emp = e.target;
  String name = emp.text;
  Employee employee = company.findByName(name);
  employee_name.text = employee.getName();

  employee.getProposals().forEach((f) {
    LIElement li = new LIElement();
    li.text = f;
    proposals_list.children.add(li);
  });

  showEmployeeDetails();
  new_proposal_field.focus();
}

void updateChoices() {
  if (choices.tBodies.length > 0) {
    choices.tBodies.first.remove();
  }
  TableSectionElement tBody = choices.createTBody();

  Iterable<Employee> employees = company.getEmployees();

  // display fist line with users
  TableRowElement newLine = tBody.insertRow(-1);
  newLine.addCell().setAttribute("style", "border: none");
  employees.forEach((e) {
    newLine.addCell().text = e.getName();
  });

  // display each proposal on a line
  company.getAllProposals().forEach((p) {
    TableRowElement newLine = tBody.insertRow(-1);
    newLine.addCell().text = p;
    employees.forEach((emp) {
      TableCellElement cell = newLine.addCell()..onClick.listen((Event e) {
            TableCellElement cell = e.target;
            if (emp.isChosen(p)) {
              emp.unchoose(p);
              cell.classes.remove("chosen");
            } else {
              emp.choose(p);
              cell.classes.add("chosen");
            }
            console.text = company.toJSON();
          });
      if (emp.isChosen(p)) {
        cell.classes.add("chosen");
      } else {
        cell.classes.remove("chosen");
      }
    });
  });
}
