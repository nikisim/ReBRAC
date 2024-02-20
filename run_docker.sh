# Don't forget to change working directory

docker run -it \
    --gpus=all \
    --rm \
    --volume "/home/nikisim/Mag_diplom/ReBRAC:/workspace/" \
    --name rebrac \
    rebrac bash
