# The following SHA is obtained from the env of the travis config file
docker build -t swa181/multi-client:latest -t swa181/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t swa181/multi-server:latest -t swa181/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t swa181/multi-worker:latest -t swa181/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# Need to push for both tags
docker push swa181/multi-client:latest
docker push swa181/multi-server:latest
docker push swa181/multi-worker:latest

docker push swa181/multi-client:$SHA
docker push swa181/multi-server:$SHA
docker push swa181/multi-worker:$SHA

kubectl apply -f k8s
# "server container needs to use my docker id/multi-server image"
kubectl set image deployments/server-deployment server=swa181/multi-server:$SHA
kubectl set image deployments/client-deployment client=swa181/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=swa181/multi-worker:$SHA