const HelloWorld = artifacts.require("HelloWorld");

contract("HelloWorld", async () => {
  it("Hello World Testing", async () => {
    const helloWorld = await HelloWorld.deployed();
    // Définir un nom via la fonction setName
    await helloWorld.setName("User Name"); 
    
    // Récupérer le nom via la fonction yourName() (la fonction view explicite)
    const result = await helloWorld.yourName(); 
    
    // Affirmer que le résultat est le nom attendu
    assert(result === "User Name"); 
  });
});