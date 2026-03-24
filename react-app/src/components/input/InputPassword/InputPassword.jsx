import {InputField} from '../InputField/InputField.jsx';
import {useState} from 'react';
import './InputPassword.css';

export const InputPassword = ({name, placeholder, state='', className='', ...props}) => {
    const [showPassword, setShowPassword] = useState(false);

    const togglePasswordView = () => {
	setShowPassword(prev => !prev);
    };

    return (<div className='password-box-container'>
		<InputField type={showPassword ? 'text' : 'password'}
			    name={name}
			    placeholder={placeholder}
			    state={state}
			    className={className}
			    {...props} />
		<button type='button' className='password-button' onClick={togglePasswordView}>{showPassword ? 'hide' : 'show'}</button>
	    </div>
	   );
};
