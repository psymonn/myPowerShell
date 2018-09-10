Ok, so this module stuff is a real mystery!  I mean poorly documented!

I found a way to have a global variable at the module scope.  It's using PrivateData.

So, in the manifest, have this

...
 FileList = @()
 PrivateData = @{g1 = 'global'}
 }

Then, in one of your module functions:

  $gl = $MyInvocation.MyCommand.Module.PrivateData['g1']

And to change it

  $MyInvocation.MyCommand.Module.PrivateData['g1'] = 'changed'
