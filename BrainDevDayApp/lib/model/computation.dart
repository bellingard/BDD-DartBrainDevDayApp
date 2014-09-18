part of bdd_lib;

class Computation {
  
  Company company;
  
  Computation(Company company){
    this.company = company;
  }
  
  void compute(){
    bool choicesOk = true;
    company.getEmployees().forEach((e){
      if (e.getChoices().isEmpty) {
        print("Employee " + e.getName() + " has make no choice !");
        choicesOk = false;
      }
    });
    
    if (choicesOk) {
      print("Every Employee has made a choice");
    }
  }
  
}