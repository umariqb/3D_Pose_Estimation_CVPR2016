function email(address,subject,message)
    % Define these variables appropriately:
    user = 'kruegerb';
    mail = 'kruegerb@cs.uni-bonn.de'; %Your email address
    password = 'Ellis=uay'; %Your password

    % Then this code will set up the preferences properly:
    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Server','postfix.iai.uni-bonn.de');
    setpref('Internet','SMTP_Username',user);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');

    % Send the email
    sendmail(address,['Matlab: ' subject],['Send from Matlab: ' message]);
end