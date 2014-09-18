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
        print("=================================================");
        print("Employee " + e.getName() + " has made no choice !");
        choicesOk = false;
      }
    });
    
    if (choicesOk) {
      print("=================================================");
      print("Every Employee has made a choice => COMPUTATION can start!!!! ;-)");
    }
  }
  
}