import {InputField} from '../../components/input/InputField/InputField.jsx';
import {InputPassword} from '../../components/input/InputPassword/InputPassword.jsx';
import {Link} from 'react-router-dom';
import {CreateUser} from '../../api/CreateUser.jsx';
import {UsernameExists} from '../../api/UsernameExists.jsx';
import {useState} from 'react';
import './Signup.css';

export const Signup = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [repasswd, setRepasswd] = useState('');

    const handleCreate = async () => {
	const data = await CreateUser(username, password);
	console.log(data);
    };

    const handleCheck = async () => {
	const data = await UsernameExists(username);
	console.log(data);
    };

    return (
	<div className='signup-container'>
	    <h2 className='signup-title'>Sign up</h2>
	    <form className='signup-details'>
		<div className='username-group'>
		    <InputField type='text' name='username' className='signup-username' placeholder='Username' value={username} onChange={(e) => setUsername(e.target.value)} />
		    <button type='button' className='signup-username-button' onClick={handleCheck}>Check availability</button>
		</div>		
		<InputPassword name='password' className='signup-password' placeholder='Password' value={password} onChange={(e) => setPassword(e.target.value)} />
		<InputPassword name='repasswd' className='signup-repassword' placeholder='Confirm Password' value={repasswd} onChange={(e) => setRepasswd(e.target.value)} />
		{password != repasswd && repasswd != '' && (
		    <p className='error-text'>Passwords do not match</p>)}
		<button type='button' disabled={!username || !password || password !== repasswd} className='signup-button' onClick={handleCreate}>Sign up</button>
	    </form>
	    <Link to='/login' className='signup-link'>Already have an account?</Link>
	</div>
    );
};
