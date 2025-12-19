#!/bin/bash

read -p "Введите путь к логам: " LOG_PATH
read -p "Введите количество дней: " D_QTY
#rm $(find $LOG_PATH -name *.log -mtime $D_QTY)
find "$LOG_PATH" -name "*.log" -mtime +$D_QTY -delete
