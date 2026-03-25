import {BrowserRouter as Router, Routes, Route, Navigate} from 'react-router-dom';
import {Login} from './pages/Login/Login.jsx';
import {Signup} from './pages/Signup/Signup.jsx';
import {User} from './pages/User/User.jsx';
import './App.css';

function App() {
    return (
	<Router>
	    <Routes>
		<Route path='/' element={<Navigate to='/login' replace />} />
		<Route path='/login' element={<Login />} />
		<Route path='/signup' element={<Signup />} />
		<Route path='/user' element={<User />} />
	    </Routes>
	</Router>
    );
};

export default App;
