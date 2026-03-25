export const Popup = ({text = '', className = '', execute}) => {
    return (
	<div className={`popup-container ${className}`}>
	    <p className='popup-text'>{text}</p>
	    <button className='popup-button' type='button' onClick={execute}>OK</button>
	</div>
    );
};
