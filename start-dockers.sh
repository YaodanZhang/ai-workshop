. ./env || exit 1

for i in $gpu_dockers; do
    nvidia-docker run -d --name twtfgpu$i -p 1000$i:8888 $gpu_docker_image
done

for i in $cpu_dockers; do
    docker run -d -m 4000m --cpus 3 --name twtfgpu$i -p 1000$i:8888 $cpu_docker_image
done

echo 'distribute the links below to users:'

sleep 5

for i in $gpu_dockers $cpu_dockers; do
    docker logs twtfgpu$i 2>&1 | grep -v NotebookApp | grep \?token= | sed "s/localhost:8888/ai02:1000$i/"
done


echo done
