part of bdd_lib;

class Employee {
  
  String name;
  List<String> proposals;
  Set<String> choices;
  
  Employee(String name){
    this.name = name;
    this.proposals = new List<String>();
    this.choices = new Set<String>();
  }
  
  String getName() => name;
  
  void addProposal(String proposal) => proposals.add(proposal);
  
  List<String> getProposals() => this.proposals;
  
  bool choose(String proposal) => this.choices.add(proposal);
  
  bool unchoose(String proposal) => this.choices.remove(proposal);
  
  bool isChosen(String proposal) => this.choices.contains(proposal);
}
