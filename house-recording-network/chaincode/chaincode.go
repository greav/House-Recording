package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	sc "github.com/hyperledger/fabric/protos/peer"
)


type SmartContract struct {
}


type HouseTransaction struct {
	Address  string `json:"Address"`
	Seller string `json:"Seller"`
	Buyer  string `json:"Buyer"`
	Amount string `json:"Amount"`
}


func (s *SmartContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	transactions := []HouseTransaction {
		HouseTransaction{Address: "St. Petersburg, Leninsky avenue, 79", 
						 Seller: "Ivan Ivanov", Buyer: "Petr Petrov", Amount: "5000000"},
		HouseTransaction{Address: "Krasnodar, Ladozhskaya st., 70", 
						 Seller: "Semen Semenov", Buyer: "Ivan Ivanov", Amount: "2300000"},
		HouseTransaction{Address: "Moscow, Bazhenova st., 99, ", 
						 Seller: "Maksim Maksimov", Buyer: "John Foo", Amount: "3500000"},
	}

	i := 0
	for i < len(transactions) {
		fmt.Println("i is ", i)
		houseAsBytes, _ := json.Marshal(transactions[i])
		APIstub.PutState("House"+strconv.Itoa(i), houseAsBytes)
		fmt.Println("Added", transactions[i])
		i = i + 1
	}

	return shim.Success(nil)
}


func (s *SmartContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {

	function, args := APIstub.GetFunctionAndParameters()

	if function == "queryHouse" {
		return s.queryHouse(APIstub, args)
	}  else if function == "createHouseTransaction" {
		return s.createHouseTransaction(APIstub, args)
	} else if function == "queryAllHouses" {
		return s.queryAllHouses(APIstub)
	} 

	return shim.Error("Invalid Smart Contract function name.")
}


func (s *SmartContract) queryHouse(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	houseAsBytes, _ := APIstub.GetState(args[0])
	return shim.Success(houseAsBytes)
}


func (s *SmartContract) createHouseTransaction(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {

	if len(args) != 5 {
		return shim.Error("Incorrect number of arguments. Expecting 5")
	}

	var houseInfo = HouseTransaction{Address: args[1], Seller: args[2], Buyer: args[3], Amount: args[4]}

	houseAsBytes, _ := json.Marshal(houseInfo)
	APIstub.PutState(args[0], houseAsBytes)

	return shim.Success(nil)
}


func (s *SmartContract) queryAllHouses(APIstub shim.ChaincodeStubInterface) sc.Response {

	startKey := "House0"
	endKey := "House999"

	resultsIterator, err := APIstub.GetStateByRange(startKey, endKey)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}\n")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("- queryAllHosueTransactions:\n%s\n", buffer.String())

	return shim.Success(buffer.Bytes())
}


func main() {
	err := shim.Start(new(SmartContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
