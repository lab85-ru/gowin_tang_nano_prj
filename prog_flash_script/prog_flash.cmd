@echo off
echo "*******************************************"
echo "* Write firmware file *.FS to Flash GoWin *"
echo "* Device: GW1N-1                          *"
echo "*******************************************"
programmer_cli --device GW1N-1 --operation_index 5 --fsFile %1