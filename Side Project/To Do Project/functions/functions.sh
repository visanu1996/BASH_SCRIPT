# global variables
st_date=$(date)
task_file="./task/task_list.txt"
running_id="./task/running_id.txt"

# Main program
MAIN(){
    echo "#######################################"
    echo -e "select number to choose what todo.\n1 for adding.\n2 for listing.\n3 for marking.\n4 for deleting.\n5 for exit."
    read -p "please select : " number
    
    case $number in
        1)
            # Add
            Add_v2
            ;;
        2)
            List
            ;;
        3)
            Mark
            ;;
        4)
            Delete
            ;;
        5)
            Exit
            ;;
        *)
            echo -e "\nInvalid options please select as shown.\n"
            ;;
    esac
}


# a Task: User can add tasks to the list.
# Add(){
#     clear
#     echo -e "\n################# Adding Menu. #################"
#     if [[ ! -f $task_file || ! -s $task_file ]]; then
#         echo -e "ID\tDescription" > $task_file
#     else
#         first_id=$(awk 'END { print NR }' "$task_file")
        
#         echo "What task do you want to add in todo ?"
#         read -p "description : " description

#         if [[ $first_id -eq 1 ]]; then
#         # if no task has been add ID start at 1
#             echo -e "$first_id\t$description" >> $task_file
#             echo -e "Task added successfully!\n"
#         else
#         # if there's already task inside ID start at last number+1
#             last_id=$(( $(awk 'END { print $1 }' "$task_file") + 1 ))

            
#             echo -e "$last_id\t$description" >> $task_file
#             echo -e "Task added successfully!\n"

#         fi

#     fi
# }

Add_v2(){
    clear
    echo -e "\n################# Adding Menu. #################"
    if [[ ! -f $task_file || ! -s $task_file ]]; then
        echo -e "ID\tDescription" > $task_file
    else
        
        echo "What task do you want to add in todo ?"
        read -p "description : " description

        # if there's already task inside ID start at last number+1
        ID_increment
        ids=$(cat $running_id)
        
        echo -e "$ids\t$description" >> $task_file
        echo -e "Task added successfully!\n"
    fi
}

# Tasks: View all tasks in the list.
List(){
    clear
    list=$(awk 'NR > 1 ' "$task_file")      #list all line in file.
    if [[ -z $list ]]; then
        echo -e "\n################# List of To do. #################"
        echo -e "No task in list."
    else
        echo -e "\n################# List of To do. #################"
        cat $task_file
        echo ""
    fi
}

# as Done: Mark a task as completed.
Mark(){
    clear
    echo -e "Please select which ID do you want to mark as done\n"
    awk 'NR > 1 && !/Done/' $task_file
    echo ""

    not_done_ids=($(awk 'NR > 1 && !/Done/ { print $1 }' "$task_file"))    #search for line that doesn't having Done in line.

    if [[ -z ${not_done_ids[@]} ]]; then
        echo "No task left to mark."
    else
        case "${not_done_ids[@]}" in   # case with array check
            *"$id"*) # every thing that are in an array.
                read -p "ID : " id
                # If not already done, mark it as done
                sed -i "/^$id[[:space:]]\+/ s/\$/ - Done/" "$task_file"         # insert - Done behind the line.
                echo "Task $id marked as done."
                ;;            
            *)
                echo "Task $id is already marked as done."
                ;;
        esac
    fi


}

# Task: Delete a task from the list.
Delete(){
    clear
    echo -e "Please select which ID do you want to delete from the list.\n"
    awk 'NR > 1' $task_file #get all line without header.
    echo ""
    read -p "ID : " id

    check=$(sed -n "/^$id[[:space:]]\+/p" "$task_file")     #check that is contain line that start with selected id.
    # or using 
    # check=$(grep "$id" "$task_file")

    if [[ -z $check ]]; then
        echo "no such ID : $id to be delete."
    else
        sed -i "/^$id[[:space:]]\+/ d" "$task_file"    #delete match line.
        echo "item ID : $id has been deleted."
    fi
    
}

# Exit the program.
Exit(){
    echo "Exit the program."
    break
}

ID_increment(){
    # cheap increment for running id.
    id_incre=$(cat $running_id)

    if [[ ! -s $running_id ]]; then #if running_id.txt doesn't contain anything insert 1
        echo 1 > $running_id

    else
        id_incre=$(( $id_incre + 1 ))
        echo $id_incre > $running_id 

    fi

}