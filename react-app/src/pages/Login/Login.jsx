import {InputField} from '../../components/input/InputField/InputField.jsx';
import {InputPassword} from '../../components/input/InputPassword/InputPassword.jsx';
import {Link} from 'react-router-dom';
import {useState} from 'react';
import {UserLogin} from '../../api/LoginAuth.jsx';
import './Login.css';

export const Login = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');

    const [incorrectLogin, setIncorrectLogin] = useState(false);

    const handleLogin = async() => {
	const data = await UserLogin(username, password);
	console.log(data);
    };
    
    return (
	<div className='login-container'>
	    <h2 className='login-title'>Login</h2>
	    <form className='login-details'>
		<InputField type='text' name='username' className='login-username' placeholder='Username' value={username} onChange={(e) => setUsername(e.target.value)} />
		<InputPassword name='password' className='login-password' placeholder='Password' value={password} onChange={(e) => setPassword(e.target.value)} />
		{incorrectLogin && (
		    <p className='error-text'>Incorrect Login</p>)}
		<button type='button' className='login-button' disabled={!username || !password} onClick={handleLogin}>Login</button>
	    </form>
	    <Link to='/signup' className='login-link'>Don't have an account?</Link>
	</div>
    );
};
