#!/bin/bash
#cntrl+s .....> this is for info purpose ans save it.


LOGS_FOLDER="/var/log/expense-shell.2"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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
              echo -e "$2.... is $R failure $N" | tee -a $LOG_FILE
              exit1
            else
              echo -e "$2 ....is $G success $N" | tee -a $LOG_FILE
            fi
}
 
           echo "script started excuting at: $(date)" |  tee -a $LOG_FILE

CHECK_ROOT

        dnf install mysql-server -y &>>$LOG_FILE
        VALIDATE $? "installing mysql-server"
        
        systemctl enable mysqld &>>$LOG_FILE
        VALIDATE $? "enable mysql-sever" 

        systemctl start mysqld &>>$LOG_FILE
        VALIDATE $? "Started MySQL server"
         
        
        mysql -h mysql.nani30.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE
        if [ $? -ne 0 ]
        then 
           echo "mysql root password is not setting up . setting now" &>>$LOG_FILE
        mysql_secure_installation --set-root-pass ExpenseApp@1
        VALIDATE $? "Setting UP root password" 

       else
           echo -e "mysql root password is already setup..$Y skipping $N" | tee -a $LOG_FILE
    
       fi

