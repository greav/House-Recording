#!/bin/bash


echo "Creating channel..."
peer channel create -o orderer.freeholder.com:7050 -c housebarter -f ./artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/freeholder.com/orderers/orderer.freeholder.com/msp/tlscacerts/tlsca.freeholder.com-cert.pem
echo "===================== Channel 'housebarter' created ===================== "

echo "Having all peers join the channel..."
peer channel join -b housebarter.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer0.org2.freeholder.com:9051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer0.org2.freeholder.com/tls/ca.crt peer channel join -b housebarter.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/users/Admin@org1.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org1.freeholder.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/peers/peer1.org1.freeholder.com/tls/ca.crt peer channel join -b housebarter.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org2.freeholder.com:10051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer1.org2.freeholder.com/tls/ca.crt peer channel join -b housebarter.block
echo "===================== peers joined ===================== "

echo "Updating anchor peers..."
peer channel update -o orderer.freeholder.com:7050 -c housebarter -f ./artifacts/Org1MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/freeholder.com/orderers/orderer.freeholder.com/msp/tlscacerts/tlsca.freeholder.com-cert.pem

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer0.org2.freeholder.com:9051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer0.org2.freeholder.com/tls/ca.crt peer channel update -o orderer.freeholder.com:7050 -c housebarter -f ./artifacts/Org2MSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/freeholder.com/orderers/orderer.freeholder.com/msp/tlscacerts/tlsca.freeholder.com-cert.pem

echo "Installing chaincode..."
peer chaincode install -n house_recording_cc -v 1.0 -p github.com/chaincode/

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer0.org2.freeholder.com:9051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer0.org2.freeholder.com/tls/ca.crt peer chaincode install -n house_recording_cc -v 1.0 -p github.com/chaincode/

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/users/Admin@org1.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org1.freeholder.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/peers/peer1.org1.freeholder.com/tls/ca.crt peer chaincode install -n house_recording_cc -v 1.0 -p github.com/chaincode/

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org2.freeholder.com:10051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer1.org2.freeholder.com/tls/ca.crt peer chaincode install -n house_recording_cc -v 1.0 -p github.com/chaincode/

echo "Instantiating chaincode..."
peer chaincode instantiate -o orderer.freeholder.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/freeholder.com/orderers/orderer.freeholder.com/msp/tlscacerts/tlsca.freeholder.com-cert.pem -C housebarter -n house_recording_cc -v 1.0 -c '{"Args":["init","t1", "0", "t2","0"]}'


echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "House recording network"
echo

sleep 5
echo "Getting initial state of the ledger..."
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/users/Admin@org1.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org1.freeholder.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/peers/peer1.org1.freeholder.com/tls/ca.crt peer chaincode query -C housebarter -n house_recording_cc -c '{"Args":["queryAllHouses"]}'
echo
echo

echo "Peer0 of Org1 is making a new house transaction..."
peer chaincode invoke -o orderer.freeholder.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/freeholder.com/orderers/orderer.freeholder.com/msp/tlscacerts/tlsca.freeholder.com-cert.pem -C housebarter -n house_recording_cc --peerAddresses peer0.org1.freeholder.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/peers/peer0.org1.freeholder.com/tls/ca.crt -c '{"Args":["createHouseTransaction", "House3", "New York, some street", "Adam Smith", "Some Guy", "1000000"]}'
echo
sleep 5

echo "Peer1 of Org1 is getting a current ledger..."
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/users/Admin@org1.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org1.freeholder.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/peers/peer1.org1.freeholder.com/tls/ca.crt peer chaincode query -C housebarter -n house_recording_cc -c '{"Args":["queryAllHouses"]}'
echo

echo "Peer1 of Org 1 is getting info about a house transaction with key=2 ..."
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/users/Admin@org1.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org1.freeholder.com:8051 CORE_PEER_LOCALMSPID="Org1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.freeholder.com/peers/peer1.org1.freeholder.com/tls/ca.crt peer chaincode query -C housebarter -n house_recording_cc -c '{"Args":["queryHouse", "House2"]}'
echo

echo "Peer0 of Org2 is making a new house transaction..."
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer0.org2.freeholder.com:9051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer0.org2.freeholder.com/tls/ca.crt peer chaincode invoke -o orderer.freeholder.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/freeholder.com/orderers/orderer.freeholder.com/msp/tlscacerts/tlsca.freeholder.com-cert.pem -C housebarter -n house_recording_cc --peerAddresses peer0.org2.freeholder.com:9051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer0.org2.freeholder.com/tls/ca.crt -c '{"Args":["createHouseTransaction","House4","Boston, Fun Street, 01", "Will Smith", "Kevin Hunt", "2450000"]}'
echo

sleep 5

echo "Peer1 of Org2 is getting a current ledger..."
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/users/Admin@org2.freeholder.com/msp CORE_PEER_ADDRESS=peer1.org2.freeholder.com:10051 CORE_PEER_LOCALMSPID="Org2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.freeholder.com/peers/peer1.org2.freeholder.com/tls/ca.crt peer chaincode query -C housebarter -n house_recording_cc -c '{"Args":["queryAllHouses"]}'

echo
echo "========= All GOOD, execution completed =========== "
echo

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

