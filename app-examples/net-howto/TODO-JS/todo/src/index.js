import * as React from 'react';
import * as Redux from 'redux';
import * as Materialize from 'materialize';
import ReactDOM from 'react-dom';
import './index.scss';
import App from './App';
import * as serviceWorker from './serviceWorker';

const {createStore, combineReducers} = Redux;
const {Component, PropTypes} = React;

const todosReducer = (state = [], action) => {
  switch(action.type){
    case 'ADD_TODO':
      return [{
        id: action.id,
        text: action.text,
        completed: action.completed || false
      }, ...state];
    case 'TOGGLE_TODO':
      return state.map(todo => {
        if(todo.id == action.id) return {
          ...todo,
          completed: !todo.completed
        };
        return todo;
      });
    case 'REMOVE_TODO':
      return state.filter(todo => todo.id !== action.id);
    case 'UPDATE_TODO':
      return state.map(todo => {
        if(todo.id == action.id) return {
          ...todo,
          text: action.text
        };
        return todo;
      });
    case 'REMOVE_COMPLETED_TODO':
     	return state.filter(todo => !todo.completed);
    case 'COMPLETE_ALL_TODO':
    	return state.map(todo => {
      	return {...todo, completed: true}
      });
    default:
      return state;
  }
}

const filterTodoReducer = (state = 'SHOW_ALL', action) => {
  switch(action.type){
    case 'SET_VISIBILITY_FILTER':
      return action.filter;
    default:
      return state;
  }
}

class TodoForm extends Component {
  constructor(props) {
    super(props);
    this.state = {
    	text: '',
      activeNav: false
     };
    this.id = 0;
  }
  handleSubmit = e => {
    e.preventDefault();
    this.refs.text.value.trim() && this.props.onSubmit({
      id: ++this.id,
      text: this.refs.text.value.trim()
    });
    this.refs.text.value = '';
  }
  toggleNav = e => {
  	this.setState({
    	activeNav: !this.state.activeNav
    });
  }
  render() {
    return (
      <form onSubmit={this.handleSubmit} autoComplete='off'>
        <div className="input-field-wrap row">
        	<div className={(this.state.activeNav ? 'active ': '') + 'todo-menu'}>
          	<b className={!this.state.activeNav ? 'material-icons ': ''} onClick={this.toggleNav}>
            	{!this.state.activeNav ? (<b style={{fontSize:'16px'}}>&#x2630;</b>): (<span>&times;</span>)}
            </b>
            <ul className='dropdown-content' onClick={this.toggleNav}>
              <li>
              	<a onClick={this.props.completeAllTodo}>
                	<b className='material-icons'><b style={{fontSize:'16px'}}>&#x2714;&nbsp;</b></b> Mark all complete
                </a>
              </li>
              <li>
              	<a onClick={this.props.removeCompletedTodo}>
                	<b className='material-icons text-red'><b style={{fontSize:'16px'}}>&#x2716;&nbsp;</b></b>  Remove all completed
                </a>
              </li>
              <li className='divider'></li>
              <li>
              	<a onClick={this.props.removeCompleteSheet}>
                	<b className='material-icons text-red'><b style={{fontSize:'16px'}}>&#x2716;&nbsp;</b></b>
                  Remove This <strong>Sheet</strong>
                </a>
              </li>
            </ul>
          </div>
          <button className="waves-effect waves-teal btn-flat">
          	<b className="tiny material-icons"> <b style={{fontSize:'16px'}}>&#x271a;</b></b>
          </button>
          <div className="input-field">
            <input type="text"
              ref="text"
              id='todo-text'
            />
            <label htmlFor="todo-text"></label>
          </div>          
        </div>
      </form>
    )
  }
};

class TodoItem extends Component {
	constructor(props) {
  	super(props);
    this.state = {
    	editMode: false
    };
  }
  handleDelete = e => {
    e.preventDefault();
    this.props.onDelete(this.props.todo.id);
  }
  handleCompletedChange = e => {
  	this.props.onToggle(this.props.todo.id, e.target.checked);
  }
  editText = e => {
    this.props.onUpdate(this.props.todo.id, e.target.value);
    this.setState({
			editMode: false    
    });
  }
  handleTextChange = e => {
  	this.setState({
    	text: e.target.value
    });
  }
  toggleMode = e => {
  	this.setState({
			editMode: true,
      text: this.props.todo.text
    });
  }
  render() {
    return (
      <tr
      	className={
        	(this.props.todo.completed? 'completed': '') + ' ' +
          (this.state.editMode ? 'editing': '') + ' '
        }
      >
        <td width='32'>
        	<label>
            <input type="checkbox"
              checked={this.props.todo.completed}
              onChange={this.handleCompletedChange}
            />
            <label></label>
          </label>
        </td>
        <td>
        	{this.state.editMode ? (
            <input type='text'
              onBlur={this.editText}
              value={this.state.text}
              onChange={this.handleTextChange}
              onKeyPress={e => e.key == 'Enter' && this.editText(e) }
              autoFocus={true}
            />
          ) : (
            <div onDoubleClick={this.toggleMode} className='todo-text'>
              {this.props.todo.text}
            </div>
          )}
        </td>
        <td width='33'>
          <button
            onClick={this.handleDelete}
          >
          	<b style={{fontSize:'16px', color:'red', marginLeft:'-5px',  marginTop:'-2px'}}>&#x2716;</b>
          </button>
        </td>
      </tr>
    )
  }
};

class TodoList extends Component {
	static propTypes = {
    todo: true,
    onTodoDelete: true,
    onTodoToggle: true,
    onTodoUpdate: true
  }
  render() {
    return (
    	<div className="todo-list-wrap">
      	{this.props.todos.length ? (
          <table className="todo-list bordered">
            <tbody>
            {this.props.todos.map(todo => (
              <TodoItem
                todo={todo}
                onDelete={this.props.onTodoDelete}
                onToggle={this.props.onTodoToggle}
                onUpdate={this.props.onTodoUpdate}
                key={todo.id}
              />
            ))}
            </tbody>
          </table>
        ) : (
					<div className='no-todos'>No todos</div>        
        )}
      </div>
    );
  }
};

class TodoStatusBar extends Component {
  handleFilterChange = e => {
    e.preventDefault();
    this.props.onFilterChange(e.target.dataset.filter);
  }
  render(){
  	let todos = this.props.allTodos;
    return (
      <div className="status-bar">
        <strong>Show : </strong>
        {[{
          filter: 'SHOW_ALL', label: 'All',
          count: todos.length
        }, {
          filter: 'SHOW_COMPLETED', label: 'Completed',
          count: todos.filter(todo => todo.completed).length
        }, {
          filter: 'SHOW_INCOMPLETE', label: 'Incomplete',
          count: todos.filter(todo => !todo.completed).length
        }].map(a => (
        	<span
            className={this.props.filter == a.filter ? 'active': ''}
            data-filter={a.filter}
            onClick={this.handleFilterChange}
          >{a.label} ({a.count})</span>
        ))}
      </div>    
    );
  }
}

class Todos extends Component {
  constructor(props) {
    super(props);
    this.todoStore = props.todoStore;
    let {todos, filter} = this.todoStore.getState();
    this.state = {
    	showContent: true,
    	alltodos: todos,
			todos: todos,
      filter
    };
    this.todoStore.subscribe(() => {
      let {todos, filter} = this.todoStore.getState();
      this.setState({
      	alltodos: todos,
        filter
      });
      todos = todos.filter(todo => {
        switch(filter){
          case 'SHOW_COMPLETED':
            return todo.completed;
          case 'SHOW_INCOMPLETE':
            return !todo.completed;
          default:
            return todo;
        }
      });
      this.setState({
        todos: todos
      });
    })
  }
  getAllTodos = () => {
  	return this.todoStore.getState().todos;
  }
  addTodo = todo => {
    this.todoStore.dispatch({
      type: 'ADD_TODO',
      ...todo
    });
    //Materialize.toast(`New todo added : (${todo.id})`, 4000);
  }
  deleteTodo = id => {
    this.todoStore.dispatch({
      type: 'REMOVE_TODO',
      id
    });
    //Materialize.toast(`Todo deleted : (${id})`, 4000);
  }
  toggleTodo = (id, status) => {
    this.todoStore.dispatch({
      type: 'TOGGLE_TODO',
      id,
      status
    });
  }
  updateTodo = (id, text) => {
  	this.todoStore.dispatch({
			type: 'UPDATE_TODO',
      id,
      text
    });
  }
  handleFilterChange = filter => {
    this.todoStore.dispatch({
      type: 'SET_VISIBILITY_FILTER',
      filter
    });
  }
  completeAllTodo = () => {
    this.todoStore.dispatch({
			type: 'COMPLETE_ALL_TODO'    
    });
  }
  removeCompletedTodo = () => {
    this.todoStore.dispatch({
			type: 'REMOVE_COMPLETED_TODO'    
    });
  }
  removeCompleteSheet = () => {
		sheetStore.dispatch({
    	type: 'REMOVE_SHEET',
			id: this.props.sheetId
    });
  }
  handleTitleChange = (e) => {
    this.setState({
    	title: e.target.value
    });
  }
  updateTitle = (e) => {
  	this.setState({
    	title: this.state.title,
      editTitle: false
    });
  }
  toggleContent = (e) => {
  	e.preventDefault();
    this.setState({
      showContent: !this.state.showContent
    });
  }
  render (){
    return (
      <div className={(this.state.showContent ? '': 'hidden-content') + ' todo-wrap'}>
      	<div className='todo-header'>
        	{this.state.editTitle? (
          	<input
            	type='text'
            	onBlur={this.updateTitle}
              onKeyPress={e => e.key == 'Enter' && this.updateTitle(e) }
              value={this.state.title}
              onChange={this.handleTitleChange}
              autoFocus={true}
            />
          ) : (
      			<h2 onDoubleClick={() => this.setState({editTitle: true}) } >
              {this.state.title || 'Untitled Sheet'} ({this.state.alltodos.length})
            </h2>
					)} 
          <div className='toggle-content' onClick={this.toggleContent}>
          	
          </div>
        </div>
        <div className='content'>
          <TodoForm
            onSubmit={this.addTodo}
            removeCompletedTodo={this.removeCompletedTodo}
            completeAllTodo={this.completeAllTodo}
            removeCompleteSheet={this.removeCompleteSheet}
          />
          <TodoList
            todos={this.state.todos}
            onTodoDelete={this.deleteTodo}
            onTodoToggle={this.toggleTodo}
            onTodoUpdate={this.updateTodo}
          />
          <TodoStatusBar
            allTodos={this.getAllTodos()}
            filter={this.state.filter}
            onFilterChange={this.handleFilterChange}
          />
        </div>
      </div>        
    )
  }
}

/* Start: for first TodoSheet */
const todoReducer = combineReducers({
  todos: todosReducer,
  filter: filterTodoReducer
});
const todoStore = createStore(todoReducer);

[
  {id: -5, text: 'Hello', completed: true},
  {id: -4, text: 'World'},
  {id: -3, text: 'New World', completed: true},
  {id: -2, text: 'Hello world'},
  {id: -1, text: 'Hamid Raza'}
].forEach(todo => {
  todoStore.dispatch({
    type: 'ADD_TODO',
    ...todo
  })
});
/* End */

const sheetStore = createStore((state = [], action) => {
  switch(action.type){
    case 'ADD_SHEET':
      return [...state, {
        id: action.id,
        sheet: action.sheet
      }];
		case 'REMOVE_SHEET':
      return state.filter(sheet => sheet.id !== action.id);      
    default:
      return state;
  }
});
sheetStore.key = 0;

sheetStore.subscribe(function(){
	ReactDOM.render(
  	<div>{sheetStore.getState().map(s => s.sheet)}</div>,
    document.getElementById('todo-root')
  );
});

sheetStore.dispatch({
	type: 'ADD_SHEET',
  id: ++sheetStore.key,
  sheet: <Todos todoStore={todoStore} key={sheetStore.key} sheetId={sheetStore.key} />
});

document.querySelector('.new-todo-sheet').addEventListener('click', e => {
	e.preventDefault();
  sheetStore.dispatch({
    type: 'ADD_SHEET',
    id: ++sheetStore.key,
    sheet: <Todos todoStore={createStore(todoReducer)} key={sheetStore.key} sheetId={sheetStore.key} />
  });
});



