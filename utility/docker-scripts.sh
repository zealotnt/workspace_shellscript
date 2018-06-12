# Cleaning for hyperledger composer
echo "Stoping all container"
docker stop $(docker ps -a -q)
echo "Remove all suspended container"
docker rm $(docker ps -a -q)
echo "Remove all dev-* docker-images"
docker rmi $(docker images dev-* -q)

# hyperledger-composer get latest chaincode logs
docker logs -f $(docker ps -a --filter="name=dev-*" | tail -n +2  | awk '{printf("%s\n", $1)}' | head -1)
