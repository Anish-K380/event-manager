import {InputField} from '../../components/input/InputField/InputField.jsx';
import {InputPassword} from '../../components/input/InputPassword/InputPassword.jsx';
import {Link} from 'react-router-dom';
import {CreateUser} from '../../api/CreateUser.jsx';
import {UsernameExists} from '../../api/UsernameExists.jsx';
import {useState} from 'react';
import {PasswordStrength} from '../../components/PasswordStrength/PasswordStrength.jsx';
import {Popup} from '../../components/Popup/Popup.jsx';
import './Signup.css';

export const Signup = () => {
    const [username, setUsername] = useState('');
    const [password, setPassword] = useState('');
    const [repasswd, setRepasswd] = useState('');

    const [status, setStatus] = useState(0);
    
    const handleCreate = async () => {
	const data = await CreateUser(username, password);
	setStatus(data['message']);
	if (data['message'] === 0) {
	    showPopup();
	}
    };

    const [checked, setChecked] = useState(false);
    const [exists, setExists] = useState(false);

    const handleCheck = async () => {
	const data = await UsernameExists(username);
	setChecked(true);
	setExists(data);
    };

    const clearInput = () => {
	setUsername('');
	setPassword('');
	setRepasswd('');
    };

    const [createSuccess, setCreateSuccess] = useState(false);
    
    const showPopup = () => {
	setCreateSuccess(true);
	clearInput();
    };

    const errorMessages = ['Password should be atleast 8 characters', 'Password is not strong enough', 'Username is already taken'];

    return (
	<div className='signup-container'>
	    <h2 className='signup-title'>Sign up</h2>
	    <form className='signup-details'>
		<div className='username-group'>
		    <InputField type='text' name='username' className='signup-username' placeholder='Username' value={username} onChange={(e) => setUsername(e.target.value)} />
		    <div className='username-actions'>
			<button type='button' className='signup-username-button' onClick={handleCheck} disabled={!username}>Check availability</button>
			{checked && (
			    <p className='username-status'>{exists ? 'username already exists' : 'username available'}</p>)}
		    </div>		
		</div>
		<div className='password-group'>
		    <InputPassword name='password' className='signup-password' placeholder='Password' value={password} onChange={(e) => setPassword(e.target.value)} />
		    {password && (
			<PasswordStrength password={password} className='password-strength' />
		    )}
		    <InputPassword name='repasswd' className='signup-repassword' placeholder='Confirm Password' value={repasswd} onChange={(e) => setRepasswd(e.target.value)} />
		    {status !== 0 && (
			 <p className='error-text'>{errorMessages[status - 1]}</p>)}
		    <button type='button' disabled={!username || !password || password !== repasswd} className='signup-button' onClick={handleCreate}>Sign up</button>
		</div>		
	    </form>
	    <Link to='/login' className='signup-link'>Already have an account?</Link>
	    {createSuccess && (
		<Popup className='signup-popup' text='Account successfully created' execute={() => setCreateSuccess(false)} />
	    )}
	</div>
    );
};
