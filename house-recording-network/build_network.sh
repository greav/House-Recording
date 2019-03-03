export FABRIC_CFG_PATH=$PWD/config

echo
echo "##########################################################"
echo "##### Generate certificates using cryptogen tool #########"
echo "##########################################################"
./bin/cryptogen generate --config=./config/crypto-config.yaml

echo
echo "##########################################################"
echo "#########  Generating Orderer Genesis block ##############"
echo "##########################################################"
./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./artifacts/genesis.block


echo
echo "#################################################################"
echo "### Generating channel configuration transaction 'channel.tx' ###"
echo "#################################################################"
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./artifacts/channel.tx -channelID housebarter

echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Org1MSP   ##########"
echo "#################################################################"
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./artifacts/Org1MSPanchors.tx -channelID housebarter -asOrg Org1MSP


echo
echo "#################################################################"
echo "#######    Generating anchor peer update for Org2MSP   ##########"
echo "#################################################################"
./bin/configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./artifacts/Org2MSPanchors.tx -channelID housebarter -asOrg Org2MSP



#Bring network up
docker-compose -f docker-compose-cli.yaml up -d

#Prepare channel
docker exec -it cli scripts/script.sh