module Menu
  def menu
    "Welcome! Get it together with a list!
    This Menue will help ya do that.
    1)add
    2)show
    3)delete a task
    4)update a task
    5)write to a file
    6)read from file
    7)toggle status
    Q)quit "
  end

def show
  menu
 end

def to_s
  description
end

module Promtable
  def prompt(message = 'What would you like to do?', symbol = ':> ')
      print message
      print symbol
      gets.chomp
  end
end


class List
  attr_reader :all_tasks

  def initialize
    @all_tasks = []
  end

  def add(task)
    unless task.to_s.chomp.empty?
     all_tasks << task
  end
end

def delete (task_number)
  @all_tasks.delete_at(task_number - 1)
end

def update (task_number, task)
  @all_tasks[task_number - 1] = task
end

  def show
   all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"}
 end
end


def write_to_file(filename, machinified)
  machinified = @all_tasks.map(&:to_s).join("\n")
  IO.write(filename, machinified)
 end

def read_from_file(filename)
  IO.readlines(filename).each do |line|
    status, *description = line.split(':')
    status = status.include?('x')
    add(Task.new(description.join(':').strip, status))
  end
end

  def toggle(task_number)
    all_tasks[task_number - 1].toggle_status
  end

end

class Task
  attr_reader :description
  attr_accessor :status

  def initialize(description, completed_status = false)
    @description = description
    @completed_status = completed_status
  end

  def to_s
    "#{represent_status} : #{description}"
  end

  def completed?
    @completed_status
  end

  def toggle_status
    @completed_status = !completed?
  end

private

  def to_machine
    "#{represent_status}:#{description}"
  end

  def represent_status
    completed? ? '[x]' : '[ ]'
   end

end

  if __FILE__ == $PROGRAM_NAME
    include Menu
    include Promtable
    my_list = List.new
    puts 'Please choose an option.'
    until ['q'].include?(user_input = prompt(show).downcase)
      case user_input
      when '1'
        my_list.add(Task.new(prompt('What task you would like to add?')))
      when '2'
        puts my_list.show
      when '3'
        puts my_list.show
        my_list.delete(prompt('Which task do you want to delete?').to_i)
      when '4'
        my_list.update(prompt('What task do you want to update?').to_i,
        Task.new(prompt('What is the new task description')))
      when '5'
        my_list.write_to_file(prompt'dont forget to name your file.')
      when '6'
        begin
          my_list.read_from_file(prompt('what file do you want to read?'))
         rescue Errno::ENOENT
                puts 'File name not found, please verify your file name
                and path.'
        end
      when '7'
        puts my_list.show
        my_list.toggle(prompt('Which task would you like to toggle to completed?').to_i)
      else
        puts 'Wut? Sorry I did not get that.'
      end
      prompt('Press enter to continue', '')
    end
      puts 'Thanks for getting it together! Took ya long enough!'
  end
