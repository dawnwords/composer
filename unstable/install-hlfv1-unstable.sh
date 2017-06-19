ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground-unstable.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1-unstable.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 8�GY �=M��Hv��dw���A'@�9������}v;=��>,Q��i8=U�(Q���D�/rrH�=$���\����r�1��{�)�\r
�RERj}��Ö{�|�-��U����z��Xn�rAY��u��4n�@k�iIu��=����B�E�'�R���H�~@�i��G�	?��������� =��ː���oS���0]����aBc����# �1a����fI��3M���i�S���*k���Pa�rR?3��&C�i���t� '����y�Am��փ�5A�b�X*g|��ʦ���^x=�� ЀMi�Z��iP��Õ���0�m�)�E|3�B^D5�l�`��b��YۻǓ)J����KA�������B�^�Cz��Ǉ�Z�t��"�zN%O��M9�P����ܹ҃��B-��T�h�с�_.�-�|���P1/-�/�K��^9��^��R���,��Z�InKHSN�����V��g��h�h�ZZƐ%��	�m��#Vei��H��K��W�,uڇ����д*��ឨ���_�hyL{�Cd*��'|-��j�̛���"�7���m��&
��AUH.+K�`8_�v`=[��7Z�nt�y׏��MR'^eޝ�y���v�[W9���G#�|�4�$�G���&����r:BG� ��9Y���B����nk��&��0d��D��t��Q����cQ��D7����o��K��hd]2��pl5��	��Ֆ,�UTHZ��!*��h���.�B��6B�F��S�5A���GO�}ϟJ��G�K�� �r��sܥ��1��:�=ܷ��.�	 ��- р%���b��Rp�tz&�
"���f�3k�W�CN�_���N� ��t�`)���g��D�&�L`C��Tb.�#��%�6�̯�e��y��UL+����R��<�k�3��)CO4�d6`E��	�M�O^�4
�s�H�Ա#�{��
�y���.��KեlL���.��+�i�yo����j#A�8D���T(��PE� �ۊ����oA�p���O�
���a��:YO�L,��:k@Ѱڼ^~��M�9b�ͪ0�G�4vY$��1�� �(u�?�D\�<EtE�|���#��ʡ)�DC�����0+�<�\s���������ƙ��Q:�P1�Ţ�?�of�S2D��	��GC1pz���ΪŃ
/���O૯@�n�o��zq�軑����L��|���?�@������pE��^�?���[��?lX�K��6�M�����?a|���}�'&���[tB<��=��=bU�`߀Me����P�S����Vؿl@ɂ�U<oG�.����?C���;���6���K]�%�}|q����;��$��z�rwf��J��x�G]���[1���9�x҆Tw7h��{@^ʖn���F�L�zV�+�Rm�{䛠׌
|���T���Ǐ^� �y�Yr6ʂ����U��١P�f��g�7�[fކ�PL0�Lh}$��0����k`���w0���	���z�[���W!f�N�2��[��ղ�P<���zm�t<1!RV�|��s����xOȀ����%�}��s1�%x�<ZIx������W`��l,�eutH@����o�b�;[R��m�L6<�@�<�N�D�ŹC�$����GQ�Ù�V��yݝ����ĩX�?��ج���il��=����N�OSq_�ۀ���.���E�?&���o�	x�54��a��7�o((�sD�z�&B���pxu�7��u$�����s��!�|4�9��SZmԧL��;<"�^00}m�1��6�q�y�"�s���\���)����Ȃ������V�����̾4�� ZR��^�,���!��S!br���}������Q"v����uhI�Z��-��P޼����-���ݨ�hx���k�w�޴�CQ�e�������7M�xm
טcӂ=�}�y��~���G\󅙜9��겄�䥈�F�&�9��y��a��e�ږ�� Ͻ�G~=CAn�ǖ�s�����g�މ>0&�RL��6�U(i?�hƇ�����
�����؂�g⌿��x�����#�m���[��A���Ӗ���bj������4G��+>�m�M�d�A�1��7��x�������)���ߺ���
��
am-�w6�]u��OO�J8�2R)�ŊpV��Y�ȳy�Z�&�'�R/`�"�e�[��В��дg�Ɂ�����w��"��W���	��=� �:X�69�`�B8��'h�m*-kDN�B��ㅮh�@J��S����&X�E����.��P��VL����S������/G���������k��
�E���B����#L<���� �W����O?��'���o��_7��T�_G'�m4Ѩ#��Q\&�z�e�R,,3�p3NG�ܔ�z�)S�%'`X�E�Db�#C���ӿ���D3��G������_d�������ov~�1���Dw�;O�������Ζv����S�V�Cwx?h��(T�u�D��2������y�q���_��G;��|��O?��g�B��'�6w>���O?�!&�?�����P�n������Ϧ���љ�:��k���0�$�b���o����������7��7����@�OF��󙩴4�p��-�c�_��6��`�1:������o����_M�����t�
�sd���$��ٳLQ�ái�ޠ\Ѱ*T�UP�Y�E]�s�ꂩ ��ǽ�ǻ�ʉ��������E�n@��$����,Ǖ���n�I.jA�E�{n�]8�Y�4�f8�3�T��w(E�0m�bMY�M�oҒ�����.Ө7��ݘ�$��Ĥ3��#C�
�=�"�׸wmuuЃ3�
��1�[��:�2��4��q����D�]�iV_(6�A��*�_�t��~�}�-V�B���P*l���p(���>h�G�VkB�M&+B��O��?k��g5[�Z����Cdj*�_a@�tǲu�*3Ԃ4�K�?�L�H�؈�����'e�|J����H�o�-�/Ym�4d��X�A�G�ʚ�fj�����3B'-\5���<T'�C����!����ʴU��� �(�[۞s�ؚ۾���z�oJ���0s}�6�5�����ո�|�n�Zw��C�L($K�l��?Д�I�mݴȡd��@�B��9kI��>��+x��"����N����6[���KL��$� �����
�k�B`��M'슻�V��n��UU��	-���3�9��1{����c"e�􃴈8�en�����,|���Ԅc�<�8s���^s����d�ϡ���5W4g�vT��D$���k��u($Өm�����$[c9�*��x76�]���L��z�&R�l�Fw�;��y��iX������s4�ߔ���++=�i�$��'���N�foކދûQg}nu�N�l���C�a���{*�UA�s�;�\��Tn��מX�c<�.��
/���*�=�ݚ�l{b�:��ī�g�'��X�����y������F����V���_v�+h�X�a
}���x��_�6o��p�
������]^�ZyE�#3뿎�>):�
T�ȿ#~�`�C׭��6��@���?����S�����[��X���[�{��c̲�g|��؎�w6���;��|���������3��������[���ϷN�G�oy|h�-���/��/K��?��b��t� x�R˦�<[�RB�f�\���F���Y�me���r,3<�^�����I�َR�6ǵZ��n�X*��l��Ųi|�$yX.������P!�>xN̕��)��^�R�D���q#�p��Y�tL�E;�q�S�NENv��r=�B�Q�S����^aX�]�#�XFbaʦF��;ّ�aǅک���n;-S��/�\�pȱ'5V=������
v?yr4��v����+'v�u�2�M�N�"-���h�{����b%ag���$wʝ��~��!ȣ|�0rrD������ٵ�T����O��g�'Y�{�-��r���B���r��zCM7m����#}���"L>;<��a�.�s�-�Z>�\kG��98�O���oFcr���cRAӬ�l!N+T�`��c�^[G-���/�eQd�4ϛi�|�B�D�v�[�H�̋,k��$�z�p|���lKW�a��<?�a5��:�L=q1�'$�(*�*C�R�Z�{�ͷ�G&�3h&+6kW�l�.�������Ӕ�P��Z<�K�):^�6�Eݕ��}���h�8��K}��[j#G]�:��Y�r'!�k���0}A��!�|��\���m���C�Gǖ�E���6`;�>�������Î���g��_?��l����������G�������6`S�_M���&��-i�~5��j�ʘ�F/v��{"OS5/S�夐'D����m�?<G�[q��V������Ci�@:F�{��ɵ�!�S�4!�P�Ǩ'Lb����.�^һ��apz�n׏9���jGtp�Hv�-Ěl�ٱX��b�9�e�̞�u8���wY� �:�]�1��H�)�Ĺ�y�*Fvٖ�2q�-dX*�ry%���3�t*��k�F���'S����e���4�t�=�n��1iҽΈ�G��4c��(̒�̉U>ח*���i"qr����c�s�{����B�-s�
��\�ep-!ŕe|@�� UD�m&��&���w�[e��y%/%hi|nF�����B�txQL4��sŌ���3R=�dc��YX}j�l�K�����	�ԉ�h�p^<�26'1��B^��*��p֬U��zB�|�)�V��4g�b�*�nvO�f4L4t=ME2�~��\��cY(������?��
l'��%?������v�w�?CG��?���m�v���;�AK5���	�!��V����?n6��\������ۨ�Yk)�.���&ܔն�r�P��n�=Ͷ�ά�v���;�f��l��+jN�C}3�A�A !@�ĤB=�N�~�;���u����#)|�a��0`��+�Ε�Rr�N�߯��1,���/�q�����ݜ��}���H��^n�b0��>9�;�~���*�[�w//�%*��d;T<�,���^S�S�`�]lt��<J������c�X/�Rtq�mo{d��a_%d��-}��b���6�c��UC�g9�������!~���Qm����>�_�~j��U��EdH/����hx���W�b��x�F�֏v�{��>~V�;�V�c����n�<p������F�}�.9�ݘs���)Ɏ&�k�W*����Z��t���_�h�������?������?�����`���?��k�.�������~�����zG�r9�KI�Z��QI$b:�#|<��:>IB<O��=�	��z�)R�7���]Յq���`a+gE*�d=�S�����y?�a�g}s���|R���٤�j��/�׳����j�?�QWA�L��㙚W��`>V܌U7�<2���*۬�$=��}�$�����Oƾ���C�Dd)��R����G���<9��_#����9����	<������G�(����O�O�?�4����������������ē�'�m�����>�u����Q��o[��g�?�i�����B��YL�Ő)���fY�
dF�q���P<OPy.Dx�Ɯ �ͦiD����������O��k�g������f��C��/]	����!*�{�7Q����4͢w�׳�U�Vۉ4�l1sT�����t��8Y�&w^�Q%-,4�2��v~�O�a�w+1��w�U��-ՊC�u;�E��
��oU�,�&�|��T��47r�n]���S���uM�����M���w�.��$A����M�����-Ӆ��_{tB����-����M����S4��&��w���w���_��Z�� �e�������l������� ��w���}}������Ǐ��g��x����x)�m./�RFQ5[����/�����E�:([���">��y��(ݎ�7�|��j@���p�c߈�8�8&3��4�u�2���x6
�}(��8LԞ���w4�[�˰���7�������i���h��hT"dHG�r�ueH:������)X�+�&�M��D_����au�p=�Rʽ���3��4�Y��Ot9dE�_��'�+E�S�3�Uy�VsT`�Wk)酻�\�xm���s��n}6��!~�{՗�8}�3���� ��5Z�� �e������O��������o�.��g���?5�B�'�B�g��O4�������'�������3����7A����ш�G$�F9Ű1E1�	d1TF19��I��D��D�1��C �8�s��h��"���p����v�����F��翹�)zj�xU���6�p��\J[ I�����o�x��_���9�M"fO/V]���׽yuCc�a��$��X,c�tJۅq:���Ϲ|��[�&r���V*�r�"8��V�������	��o�F����,M��?��O���7����?����?�� ������#���]���f���`��	���p�C{4�����ītX����u���Z�e���Z���m���ڣ+���Q���G�S���4bR��y�I� 2��)�#Y���4���Z���9�����X��h�_9��FS�+���ѷv���k��]�s��Q��-ֳ���2�cyҡ4��8ȭ�x���m����jM�)���F]�vx%��f2�]��2��V.��?f��NƈS�5�ۘ�C���[����?�G��?���2]X����G'��~�������m����G�?�_��'���'���P��P���-��c����h�����`����v�������?���"��3��c�#�@<�o���������`�N�����~�H�e�	
}�ر���ҧ�
��%u��H�h�0��W�CY�������1q�Ǟp�H�.��E��sq�Ͳ��� S���&d[�^�Ӟf+�L�%�����Y9?���������(��+
R8I��J���c:�>�'�$BNl������p�C[�\���-��c������5:����[��������C�������{��1�	����Ǯ�:�����-�?���?�������p�LY�H�,�c��r*�X!f"���$ai�Ҝ���3��i� �<ɓ�H�L���������+�?l|��3G��K��t�v���k��]�&�t�iY=��%�Ü҄v�M��N�;��b:J�����s��z�x�(��}T����c��K.�C�L�4�n�ަ+fl�����I��+��x+]X�!��=Z^�!��e�����k�N�?��Fw�F�� �>����������@��-����2��?v��	�������? 6ޙ.��!_�?��	�����#�C���͑g�Ë��f�~΄z�`���/��8?|3���o����x{��5~��n���Q��ęG/��>���x���tG����Ak�1,�V>���RWr�_��F�ś�°�z�>��P�	'�����"�L���\�����,�sq�U�_>��:�xt�u���N�`U+u8ľ�H��c���0'�Y E>O�x�'�8]�y]�P�/tU��`��=/���GK�AԷn .뤿s,�ރ��=��[Q�}���a��j����di��������ϰ�=��Y��c��a�5�4>�sUd���o\4P��ה�{��P�ס���)�(��h��ݒ�L��~Od6������0��a�<�d��D+{�����T¾�*�V�j��X��;�08���o�e�����z@p�*��p��}\�4�s-sV���F�֩�߅k9��,)�h��/�zǹ��w��o����F�������]�uB�!��5:����[��������C������C�ɿD<�D�O�4��MЅ������?��o�����9V���Y���f���o�N�?�j���I��&hF��_W��o[�I�I��7B���G#����Д�����4����^7+�.�|^��&�2��|��߫�::�w��������E���D��X	r�����|^Sg/�c,�g�l*{�]RN��k�G�O%�������2�pō��v�������V�'�6����#El�*�n~(����=��I���5}�����:��ӌ����(�7�#ӻ}p�*j�߈�g�;!����+�7ɂl��Z;7uv�1�������iqFO�e,jv1�]���L�?���m�L����
���]�uA���w{4��`��E����?��5�?������)E5g�9�E,��Nd5�n����[��^=Ե������?��?y:��cF)���������˛wr�����&tnf�)�pr����ý����Ѯ9�3&lMw����&Y�M�����36�ey�&�{��j�p���ц�|p͏J�_���,*h)��n���V����=�������@9�Wg���vz.FEV�bU�2e}%���*E>Z�lEc[��պhL����K»P��T{��?���L����
���]�uA���w{4�����������������߮�����x����8������3��"��7A��ğ�����������=	 Z���u�'������FhY����������߶�Sē�?��G#tE�y"�<�
gh�#>�x!�p2"pJ�3<�,�9!~y�d#�%��ds��sN`�s|���7]��%^�?�6�7���5��KW¯�?u�
E�^�IT�:z�M�(׫�=��Ex�Ǖ��V�vs�pZ	Z1V���������B	!+�.(s6)�n�4}���d�WkÎ(g�K��}���`���N@�@�
.Z/����.��s2A�Q�
��;��M���w�.��$A����M����P-Ӆ��_{tB���k���?C�AS����O��	 �	� �	� ���?�j������?����o#tF��? �����g_��$��7�?������T������{��/M��Ђt<Tc�7=����!�_�(�D��I���;�}���`�)VÜ��վr�Mlv1�j���}�.��6��)aR�lJ\�+����I'=��u�Z25���0o[�K��z����`'#��O��ϷG;�o�v�!C:���O��ʐt��yL<�_]FX�D��Q�&���3İ&�r��^M�����^����;�^ Cq��)��� �<�g����t���Fcrѯ�z5w.�=bQ�֣����.\�������h��cf�;&�\�z�\�G�E�����|��� ��5Z�� �e������O��������o�.��g�O��	 �	� �	�Z�������Fx��?���w�&�������	�����o�F��f�a�<�\ȸ�86IsFH������;m���X�������@���@BLj��^��__;/y�z��b���AV+�m�}�>��}b�#�O:�>���.b"&�8Nc6�������o��k���=NN��9��B���͈�<Zo�lu���z7�����o��T���^�oo�����$=׫���aj#�y098�+��a3����T<��|�tT���Yqq
��w���M���[���Op����ׂZ���#�������	
��: ���C�������ǜ���?��:^�_��3���������9�����}�Xh������?�h�?�h����M�?�h��?<�Q��	C\*�|�0!���GTB4�Qsx�q&��	�r4O�1��P��g�?,�Ԃ�9�#D�����_u�d��u��:�J?��|�0Mc�\2�!���?c�d�i�<�
biǼՓW��kKw�W�֖�M��(���7)޴��`���r�:۔���eۻ�.b����(�����94|����������9 ������Z��Ðh����;��p��� ���'���'� �׀�������H�?�?4d��?6�����,����G���a�#� �׀�������H�?�h��?��������s��?������� ����or����� ��s�?$��?C������i�����
�G����Q@PlJpi��d,C�L��Bx�qB�t@�a�޷TJ@�ǯ������;�?��F�g�Jf��l+bmƘ��yz�I�Ew�C>j{e�����<�ѻ�DF�By��t�9����U*`v�9�?[���dId����������Ìwy{tXE}��g�(��9��(�����>�!��a�p���kH�?�4t�F�� ��|n�������������?��h��?��C��!��1 ����"��O3�c���_~��q�{��>����ΐ�kt�akc����K�nD�c�/�?��[�q4}3OC�:��shk�������.6���7#�;�ӏ��$��P�I�=z�I�17[����HwL]�����pn�Ѷzs�d/�S��_����3�}�ܥxt{���Z�v���g,��������E��d�\���c�/���<�
��n�f���c����������а�������s�?$��?"���!������������������>N�??����8GQ����G��?|���#hx�k�G���r���ן�Ix�� 
������7�:~��� ��o��a��9���/1�P�Eu��?�Q��8�j���]E��h�]�׍��,җ�'�.�����]��(���+�?K�V�f/�Uju��V����??������#_�ao*M�:��������\�z��fv�B
,猗b����V�+�;��H�]/���h���+{��|��⑞x�d���+o�Ŭ�ǽ�x��ÁH�~.eOʹ��"��_�^�U^f��/�ߗq�\��,���*�0����L�b�ò}�N�ˑɒ���Ê�{�|��-����z�2L��9K�w%�h���S�7	���w %_�W���f���U����2��i:";2ڸ�o���i�"r�����=�{��6����J{K�ğm��P�7����A�Ղ:���.��n�������/��ZP/���GH����3�������w�����4<���l!㭣�,H��������������h��^C�}����T������u��'}�s2$������SvW�5?�y��)eM2r��'#5!0���
c��v<�ym;+��1��	���0w��&^1�j�����;�ڐE5����o�/�Zw[��f}����^���z��(�^�ʗ$k�+�R�/ό�]�$N*�^Y���/E�V{���;jY�R���G��Nxj?���9��9�;�/Ej-06���vLg����3��h�]�IT_�=~���q����m8ӥ��܇²���+�����a��wd��iG��0C}�lv�5me��P@A�/�����Ղ:���.��n���C��9������� ���3O��$��:��/�w�o^�u{c+{���U����UՋ4w_n_�ݶ�9�����՗�V�����7��j�rq^a3Ͻ�����rߩO:�����:3_gw�~����4��m[�5#ܴ��)gE��JG���+��OG��j y�`�������b�p����զ�6���Ĳh�/�.6>�$_���p��r��7J��a���z92$�k��7�@���=��Ǿ5�3�P'r���E���)��v���l�I��m��u7cZ�W�\$ą*b�k:�0��:K}B��ڂ#&+k�V^:$ٞ9?G�V�?���$��d�'��ZP����z@A�A��9@��?����O���I��ւ����� 
�g���(�u�g��(����X����ɘ��o���M�K�^����� �����S��������8�����8��+���Ö��dϜ���嵻���d�yڦ�W+���#�٦�<kGg7��NX�wzu)�y_Pv��x�ag5�[�H�݊����6�u�ׇ�=�=^�y�Z�j�)�=���N�M3�c.����n5���w���F�:�eC��o�N��̲����A�J"0�`?ڶ����@T����=����X���j���P�O�?9��W~V�s��?G��֡�j��e��]��F�?շ�><�Z����χ�ޠ��C��[�Z�+�ܱg#m�t��V]���F�E]��95��N�U~nxo,hd)�64�Q�Gl{WG�����.����;l�2���:����[����V{��{�"x��쉊Թ������>b;�0w��9�VR@Ƌ��/قN�ʱ�����=9%�%����^4��PN²𫔡�x��p�+mv�~�x�O�H�?��k��?(6���5���{W�����T��JԖ�`ѵ۱F�6`Rׇ�3\�YgQ�o��R��0�eI���Pف[Uf������3.H�5�������:��hل=��u[�L�9����P����=�����G���\��П�
��w�#5�ʃp���t�ÍXm����2��u�������S��+Sʍ��=y�-��%���r�M�B��	��������~����� ���������P�� �_C�����@u������?�7N���:��sO�?�_j�����m5lӟ< ���q�'�'��$�h����R6��� ���4�S��@��4�?�:�� J�$%b�dX�M	!e�$d>d#�H� ��`IAH#�b�8!c�������?(�?��O��W-���7�{�8V�{��_�ZW�T�:M��W��7hY�����Z�Pէ���s��yDo��]'�"�j%�I^kn����qt	�鲿�Y�?]5yL�Y��I�m�a��ֲ�p��c��]���-��[�~:�Z��sR���h1�C��aw��;��I5�G(��$�$����4z��b�Ɓ����9 �����/���T��7����}��o�ρ��?����߰����@B�������ZШ���������H����}���@����
 u ��>�!�������F�7�o^3J�5Έ/�7^�MZ���������Ҿ~hg�8c}�ç�)*��_DY�^�����xs�V&���:S�lZ�H��Y!�.�Yc֣s�M���,%�^�s�����aO�S?n+���sy�ۖ:�B�sH�|ݙC+%�c2��Ɣ��EJ/�W%����[��b�oߚt���&��>E6D���}�%٪z�ˊ�-;�i�&�RvM͏m�R��IiI_�E�ڱ3���f6й��5�I\�z�\���*i>b�����t?_9]z�����I���v�4��5 $��4�F�,o��?��C���'��a�O-@����7$����G��u�?��G���y�?~4�GA��ޯ�)�dA���?�=�@��&����a����_�S�������?����W����H�I���u��A'���\���F)���@��BJF�@�!˦O4%/�x�p���	Q�������?n��W~g��1Lʶz9��]x�n��RH}��������h�e:��k��?��_~E�@��[���O<;�!��|4�KGu������}�#��?H�?����5��H�� ��7��$�$��-h��!� ��7�����OCh����Ox>&��gS��Y6�)��}W�<!0,�aG�&E$s�:J�8!8!�"��+������i������3X�9'���k��Kt�f>q����/��X�G+g��k��)�`�˼B-c�88���pgQ�qu\c2I�����w�c�b�I���z|��+Bi��r{6gZz�;e���w�L���(��$����_jBS�?D�����	������_-@���~H�����{�����Z �?�����������?��jBS���� ��ϭ����I���kA���ߚ���������k ���o������?�����Ղ��D�����[�!�����?kA����Y ����������������Pm6���O���rQ�'\n��c��b��r6���������F��w�Y��ۮ�]����U��/U��v4*��.�n�*_G���P��DHyV⒀@D���!A�$��)O�o�v�t��gzFY�Ѵ�s�Su.�����u.Q/^��p]��1E���I�oy�+��������_����w���{������n]�V��2��2��24�>�y��{/����_����^se�ۂj��_��`Se1,�͠�Ep	U��"�9
�RoF�X �G�p0���f8�!�ބ��w��~�_?���_��������W���_���?�����߾�j�i�j_w��܆��6t���'�߆��6�
PMP�+�������}�ͷ���	�ߛ'�?z�2�<��,Y�aC��I���~�.��A�z�8����dlܘ��5�X�a�4�9D�T[�3�8�S�1ç�L��U���4o���C�)��a`�f*�	�3`��n�I&[��PmD=l�y�ʐ�Y�GL��%�P�n���pG��;�	�`HqV�͔@���c�`c	:��ц��<���!Ԇt[M&Rq���V1iQ	�5l�)��ƌ�,ƴ����v�c!�;#���$��*䝢�d.����x�8�pNZ�1�9�L��D�X�;�Ћ�t�'(,�xwv�VI%�q5'DQaܳ+�\*���`R�Jʨ�:x6�k�����U�3�������|����҄���u�	���|�P�RCR����dH6����:3J��q�T+�kdm�i
q��t�C%�$�LB)�쑹-] ��'/]"Udӓ*6;��!(�o�� zB��1�p��M�Ny�X�0�� �v��=��0�:��!�7WK<O�B�je�{\Em�EٌB���(�)V��$F�P6��\!����5b'g�GNG��`��+�`ˍ�a�q�}-�hst��bt%�% ��T:�B	\���f���q��8Ӷ
$Y��Ҥ_bQ�Q��?	�)7�	Q#$��]�_�)�ħh������"�O��?1�b�A�~;��+�m��Z#�LD�xR���8���ŊR�;�C����z��0�|�7�Z�+X��#Q�l\�M=}f���l��d0n�<'Z�F=��D;kB�q�wE?[�LZhEƃ�HI4Rt���'M5FU�����ֳd5�m����r�+���^�Y���T���M2t��@Y�a�R���x�YֈO�>�YRv����(��D��iƨ
f��D��@?�2��ә6�N�e<Qj�p/eGd%�l!�Fв^jT�U����|{$*V�h]�,�O.��l�۷&x]JWJxjP12E��׳J;hO�VL t�A�:�� �G�%���A������B��X���8k��n,|�`�ѣ�1��2_=ǜ��f�K�{MIK*�a�Ke���5��DA��+�8����Mf�r�T����Ep�<�U���V�Q�&���|7�p��9���A�W=�Z=��T�A���z���Z�SÚ�� U�
�]P����.W0us�*A��*��,�n5�^���@�+%���"If�Z�p]%J�U-&��V OSa*����2AW���Il�IN;Q�gP�� 9	D����|z�K���7��<��:� �J�V]��������e��ٝ����T��5Ph���" ��J�]��eo�prV��o�����ƴ�������ݙ���.��]��vO
/W��ɚ�^S�-��٪�&�g����܄��Dy?C��)��&�����2�|�@L'��W��A�H�Ѩ4)�qy��U��f#E�)�6�p}uX�'�����P�T���PL�3Y�:�+�fq7���I�R.��}Y�k4Q�RRCS�F�*��HI�'�5�*�)��Ӟ��f��<�����;-S��]U�#��Z��^������~+ݒ;D�۪UU	��R�#���V��!�`�lr�_˄���/=a�%:��H�Y�Ȕ�H5˄��L �v�A���bǏ���D,��h��w�P+G��_�Tn4��~�>`r�ғ�D��� �(�O���ON
qZ�r�����B�g�P�iB,�E+Ծ�7,#9A�`-�W��0ѡ*I�6k��j��K�J�-F��2�B5-�O��^͵�`":F[�pi���x���P%/��6bͲěS S\�Е^6DC���$3\+�� �*�b���9��ތ�Ð��-O�wESS�1���΋�΢-���w��ŧ.@���៾A�0���{?�3C��݁����;�ʿs���>m�O[�ӹ��o_j/=|f��%��
�9 �F-�A�����@��b5Q���-�@�b� ):�-�������������T|�%0L�T�f��NJb�-�U4�k��r7��⨢$z�C3�JmR	F���M�����-f�0�?5��y�2��ɜ�<Z��3�s�I)��Z����u���V ��ꍐ��+�l+׭WڦME� Z]!4 �r�����۶��
%���]���p�S���7�2�����J[?��ϱ�s|j�[kճ_��֪�1k��{��n�=�ƥK�6�u���z}�)3xbe|����ފ����U��j���s�J���q��E󗠟�[4Y�qmU�F$�;½/A��3����~l��-�e�%���%�z�\�ͩ~~m���G�G���#d�2�OixU�;��
�9,З�R��d�ކww^���U���,i�+4��x~�@�߷>��� �<�=�[4U�ry��P݆nn�F��Z& j�0��|OO����)��8��nߞ���OA���<
ݚ�!I��8���A��CEW�C�"�p������3�����?�tŰ�+�b� ����@z�?�ș��o������`��GPQ��f	JP�X3,D� .�x%o�bX@�p%E��"*b�09v`��Ϻ�������K�?���������y�ie'\,��t|yR�.�x��q��܅�r^�Q�ҽ{�+�����Y���Nz>����?l��{#�῭�u߷�����y����M�U�_;*owq  ���\ �_�yR�r5�مl���G3z��HB�._-(��O ,BhƩ�h�r�r�O�RZ��jP�Py
��ኘ�j�4��=��9r�/���eI��y�3�n8Ǥ3~(���v}�V8I�)�Eٳ�骱�=.��{��i�OǶ����>C�eߑo9���>ݱT	��Cs@�mj��;2��v�'(���S33 ���5]6\N�������>�F+-�ߪ;$��!�-�����-��G���]��F)UQE���x���ظn��qݐ�c�a���P]-���Q��u#���׍<6��pl\7z�ظn�౱i���H���{���^���餍����s-�h� �C���=.�����R�G��?����#��/����o
N��E��"��(����lۦ}{u�EMC����B��"� TI�Bq�2"�m /"��,��=��4{�����(!�(���Ip��\����_}�C~Ňܾ�XC	|� [Gl���B��^8h�Sw��5�k~�B�Vă�<>p��eP�'����v�LϜD<�S�A@��i�A���q^-H"֙�A����o]!��,�w�� ��FN��̻q�~�w���/#t!��چ#tRr�qLz ! �ܱ�"�7%�ݝe���@�C>��� ��m͇ ږm�G~�f���6w���!��_�_C@�y%���k��	��"s�ӣ_}*��p~o�N�y��6%��^(|e6�{D��ZV�`�/��-�O�i�C���=H��ڜ/Q�=����ŏyP�ӔW�Ԯ�1{��+	>�!��Ŷ��R`�lM�Z��k����� MY6��&!�iO�z�Vb��#�0 ��y�(��M���!~�7uo���Q��{��������?�����f\�!�/�e�Ăk�����n$]�/T �__�L�;�骇 
2�`��ñ�!�n�{WI�˿d������$Y��`������*�ON�/���
��^���͐��bT}B\�5�&xF��'0H2��BK>������҅�x�SʣQ����@�Z��n�q��)g�}�5os�we��F�)������[����������S1�^��I�ɺ�j 6]�r����:≁sxC�ƻH��ۋ[�b�CD�d� E���՘�&�Hu\��b��h�r?���jΦ�IV���Ϋ�2���;1w �3��_�My������������O��7����Bf�vt��2˴]�hj�8@�x֜�I�ș�Gȩ
�1Pm��|�GK����I�[�ߏ�	��d���v����
\�,�Dt^�S�ԝ�tjZ���l5'8� �9��H�����4��'(��9�(����8?m�*Y�=���t���7�ё�����s9:t��j�\!�L��st��ݣh��<s�4u�ș�b6}��W�voeF�I9���u�ۄ���e6��OM�#�B.z�-��׺�F~�4��-�c;}��jM5��	?�jKt�ȁ��q4Y����L��)� �z�<0��./�s�������	�����=��R�/������V��������>6�
=.D������6D�6E�5HE	�ɘ*ٵc;IU*�R�
�"u᜝ƪ[iҖJHl��L�,��c��X`hG&&�"q���N�MT�R޷$��>���|w���&����ѳH� Iź�Z.����̟׼�{��fzs7�
� � ��.�mLUf�v����bw<L�0��a���2<<��?X��_\�׬��X/�'�
�ؿj�9��a�5)��YӶk�&�4{��qZ�\���?8��C;2�k(9��� ��_��<sq�l��K�V�r���Q�?���Z�C��.\]L!�Ar��z�+������ocپ�=�>�h0�B�����Bh!��ĉ�%5����M�
1h�'RG��?�H���}AE�{���� \U��:��q�����Q�9�!�]���`��J���z4R�h�sct$�rZ��z>̷M��_��s/ V2� sJl�Y���*�8� �ۥ~����h�6�-e���6��s�D�ن	6�ؒ��Y�  �=
oԷ+��@�$���"�D\�-r��>E2]�lʑWn��}���f�/�?��GV�~ƄÞX\5�Jf���vI�Jݥ�Y	~�+���:�!��z������rM���
�J+�NP�ʺ�4�7�̴�4���fY��Kpڭъ��(׶�V��g;��s*��dԜ�Q3��P�u8���hwuy<��8��4]'�&1uO��İJ�a[WȌ��h�]�,#�3��d�RN�U��LR4JD)f��5�5��|������vq��k�������w
��fS��g�^�{���J����Ҝﻰl2����HBf�I��eB����M��_�6�rk|��<M5��(�ؕ�$c�,JR6ْ����&[�M���z^0/q�c[�u����w�/�<H�����/>��������t&����� ��7������=��������g#)7�"�.�"�����3���3�?��3�?��3*ꠢ�?��3�?��3�?��3�?��3�?��3�?c����8ǿ��٪�w�8[u�f�0z��C�F�g�F�g�F�g�F �@ "�?�R�� � 