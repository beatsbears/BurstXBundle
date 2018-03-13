#!/bin/bash
# BurstXBundle
#
# Created by Andrew Scott on 2/10/18.

WALLET_ID=$1
PLOT_FILE=$2
START_PLOT=$3
NONCE_SPACE=$4
MEM_USAGE=$5
THREAD_COUNT=$6
CORE_USAGE=$7
LOG_TIME=$8

echo "#!/bin/bash" > tmp_plot_command.sh
echo "./mjminer-master/mjminer-master/plot -k $WALLET_ID -d $PLOT_FILE -s $START_PLOT -n $NONCE_SPACE -m $MEM_USAGE -t $THREAD_COUNT -x $CORE_USAGE > $LOG_TIME.log" >> tmp_plot_command.sh
chmod +x tmp_plot_command.sh
