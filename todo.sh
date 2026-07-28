#!/bin/bash

# File where tasks are stored
TODO_FILE="todo.txt"

# Ensure the todo file exists
touch "$TODO_FILE"

# Function to display the menu
show_menu() {
    echo ""
    echo "=============================="
    echo "       TO-DO LIST CLI        "
    echo "=============================="
    echo "1. View Tasks"
    echo "2. Add Task"
    echo "3. Mark Task as Complete"
    echo "4. Delete Task"
    echo "5. Exit"
    echo "=============================="
}

# Function to view tasks
view_tasks() {
    echo ""
    echo "--- YOUR TASKS ---"
    if [ ! -s "$TODO_FILE" ]; then
        echo "No tasks found!"
        return
    fi

    # Display numbered tasks
    nl -s ". " "$TODO_FILE"
}

# Function to add a task
add_task() {
    echo ""
    read -rp "Enter task description: " task
    if [ -n "$task" ]; then
        echo "[ ] $task" >> "$TODO_FILE"
        echo "✓ Task added successfully!"
    else
        echo "Task description cannot be empty."
    fi
}

# Function to mark a task as completed
complete_task() {
    view_tasks
    if [ ! -s "$TODO_FILE" ]; then
        return
    fi

    echo ""
    read -rp "Enter the line number of the task to complete: " num

    # Validate that input is a positive integer
    if [[ "$num" =~ ^[0-9]+$ ]]; then
        total_lines=$(wc -l < "$TODO_FILE")
        if [ "$num" -ge 1 ] && [ "$num" -le "$total_lines" ]; then
            # Replace [ ] with [X] on the chosen line
            sed -i "${num}s/\[ \]/\[X\]/" "$TODO_FILE"
            echo "✓ Task marked as complete!"
        else
            echo "Invalid line number."
        fi
    else
        echo "Please enter a valid number."
    fi
}

# Function to delete a task
delete_task() {
    view_tasks
    if [ ! -s "$TODO_FILE" ]; then
        return
    fi

    echo ""
    read -rp "Enter the line number of the task to delete: " num

    # Validate that input is a positive integer
    if [[ "$num" =~ ^[0-9]+$ ]]; then
        total_lines=$(wc -l < "$TODO_FILE")
        if [ "$num" -ge 1 ] && [ "$num" -le "$total_lines" ]; then
            # Delete the specified line
            sed -i "${num}d" "$TODO_FILE"
            echo "✓ Task deleted!"
        else
            echo "Invalid line number."
        fi
    else
        echo "Please enter a valid number."
    fi
}

# Main Application Loop
while true; do
    show_menu
    read -rp "Choose an option (1-5): " choice
    case $choice in
        1) view_tasks ;;
        2) add_task ;;
        3) complete_task ;;
        4) delete_task ;;
        5) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please enter a number between 1 and 5." ;;
    esac
done
