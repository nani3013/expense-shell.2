#!/bin/bash


LOGS_FOLDER="/var/log/expense-shell.2"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$( date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER$SRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


USERID=$(id -u)

CHECK_ROOT(){
        if [ $USERID -ne 0 ]
        then
            echo -e "$R please run the script with root privileges $N" | tee -a $LOG_FILE
            exit1
        fi
 }

 VALIDATE(){

         if [ $1 -ne 0 ]
         then
            echo -e " $2...is $R failure $N" | tee -a $LOG_FILE
         else
            echo -e " $2 ...is $G success $N" | tee -a $LOG_FILE
         fi
 }
  CHECK_ROOT
         
         dnf module disable nodejs -y &>>$LOG_FILE
         VALIDATE $? "Disable default nodejs"
        
        
         dnf module enable nodejs:20 -y &>>$LOG_FILE
         VALIDATE $? "Enable nodejs:20"
        
         dnf install nodejs -y &>>$LOG_FILE
         VALIDATE $? "Install nodejs"
         
         useradd expense
         VALIDATE $? "creating expense user"
         


