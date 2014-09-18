part of bdd_lib;

class Company {

  String name;

  Map<String, Employee> employees;

  Company(String name) {
    this.name = name;
    this.employees = new Map<String, Employee>();
  }

  String getName() => name;

  void addEmployee(Employee employee) {
    this.employees[employee.getName()] = employee;
  }

  Iterable<Employee> getEmployees() => this.employees.values;

  Employee findByName(String name) => employees[name];

  List<String> getAllProposals() {
    List<String> proposals = new List<String>();
    getEmployees().forEach((e) {
      proposals.addAll(e.getProposals());
    });
    return proposals;
  }
  
  static Company fromJSON(String jsonData) {
    Map data = JSON.decode(jsonData);
    Company comp = new Company(data["name"]);
    
    Map employees = data["employees"];
    employees.forEach((k,v) {
      Employee emp = new Employee(k);
      comp.addEmployee(emp);
      
      List proposals = v["proposals"];
      proposals.forEach((p) {emp.addProposal(p);});
      List choices = v["choices"];
      choices.forEach((c) {emp.choose(c);});
    });
    
    return comp;
  }
  
  String toJSON() {
    Map jsonData = new Map();
    jsonData["name"] = name;
    jsonData["employees"] = new Map();
    getEmployees().forEach((e) {
      jsonData["employees"][e.getName()] = new Map();
      jsonData["employees"][e.getName()]["choices"] = e.getChoices().toList();
      jsonData["employees"][e.getName()]["proposals"] = e.getProposals();  
    });
    return JSON.encode(jsonData);
  }

  void init() {
    Employee e = new Employee("Simon");
    e.addProposal("Play with profiling system");
    e.addProposal("UI for the update center");
    employees[e.getName()] = e;

    e = new Employee("JulienL");
    e.addProposal("Scale application");
    e.addProposal("Try fancy web framework");
    employees[e.getName()] = e;


    e = new Employee("Freddy");
    e.addProposal("Home-made code coverage engine");
    e.addProposal("Markdonw HTML");
    e.addProposal("Have fun");
    employees[e.getName()] = e;
  }
}