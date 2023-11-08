//Program to transliterate tamil text to english.
//requires a map file

#include<stdio.h>
#include<locale.h>
#include<wchar.h>
#include<stdlib.h>
#include<string.h>

struct table{
	wchar_t tamil[10];
	wchar_t english[10];
}tamil_map[1000];
int	n_characters;

int is_d_v(wchar_t character, wchar_t *d_v, int num_d_v)
{
	int i;
	for(i = 0; i<num_d_v; i++)
	{
		if(character == d_v[i])
		{
			return 1;
		}
	}
	return 0;
}
//for \n \r \t and [ ] 
int is_non_printable(wchar_t character)
{
	if( (character == L'\n') || (character == L'\r') || (character == L'\t') || (character == L' ') )
	{
		return 1;
	}
	return 0;
}

wchar_t* transliterate(wchar_t *token)
{
	int i;
	for(i=0; i<n_characters; i++)
	{
		if(wcsncmp(token,tamil_map[i].tamil,wcslen(token)) == 0)
		{
			return tamil_map[i].english;
		}
	}
	fprintf(stderr,"No english character in map file for %ls\n",token);
	return NULL;
}

int main(int argc, char *argv[])
{
	int 	i;
	int 	j;
	wchar_t d_v[11];
	wchar_t vowels[13];
	wchar_t	buffer[100];
	wchar_t character;
	wchar_t token[3];
	wchar_t character_previous;
	wchar_t *character_transliterated;
	wchar_t character_next;
	FILE	*map_file;
	FILE	*input_text;
	FILE	*output_text;
	fpos_t pos;
	if( argc == 2 )
	{
		map_file = fopen(argv[1],"r");
		input_text = stdin;
		output_text = stdout;
	}

	else if( argc < 2 )
	{
		fprintf(stderr,"./tamil_english map_file or\n./tamil_english map_file input output\n");
		return 2;
	}

	else if ( argc == 4 )
	{
		map_file = fopen(argv[1],"r");
		input_text = fopen(argv[2],"r");
		output_text = fopen(argv[3],"w");
	}
	else
	{
		fprintf(stderr,"./tamil_english map_file or\n./tamil_english map_file input output\n");
		return 3;
	}

	//set locale using values of environmental variables.
	//LANG must be set to ta_IN.utf8
	if( !setlocale(LC_CTYPE,"") )
	{
		fprintf(stderr, "Locale not specified. Set LANG=ta_IN.utf8\n");
		return 1;
	}

	//read map file and fill up table
	n_characters = 0; 		
	while( (fgetws((&buffer[0]),100,map_file)) != NULL )
	{
		//ignore all lines beginning with a #. Do not process them.
		if(buffer[0] == L'#')
		{
			continue;
		}
		swscanf(buffer,L"%ls %ls", &tamil_map[n_characters].tamil, tamil_map[n_characters].english);
		//fprintf(stdout,"%ls %ls\n", tamil_map[n_characters].tamil, tamil_map[n_characters].english);
		n_characters++;
	}
	//store dpendent vowel signs and virama
	d_v[0] = L'\u0BBE';
	d_v[1] = L'\u0BBF';
	d_v[2] = L'\u0BC0';
	d_v[3] = L'\u0BC1';
	d_v[4] = L'\u0BC2';
	d_v[5] = L'\u0BC6';
	d_v[6] = L'\u0BC7';
	d_v[7] = L'\u0BC8';
	d_v[8] = L'\u0BCA';
	d_v[9] = L'\u0BCB';
	d_v[10] = L'\u0BCC';
	//d_v[11] = L'\u0BCD';
	//Storing Vowels
	vowels[0] = L'\u0B85';
	vowels[1] = L'\u0B86';
	vowels[2] = L'\u0B87';
	vowels[3] = L'\u0B88';
	vowels[4] = L'\u0B89';
	vowels[5] = L'\u0B8A';
	vowels[6] = L'\u0B8E';
	vowels[7] = L'\u0B8F';
	vowels[8] = L'\u0B90';
	vowels[9] = L'\u0B92';
	vowels[10] = L'\u0B93';
	vowels[11] = L'\u0B94';
	vowels[12] = L'\u0B83';
	//read i/p file and convert
	//get character(logical), and then compare them.
	//character_previous = fgetwc(input_text);
	/*if(character_previous == WEOF)
	{
		return 0;
	}*/
	//fprintf(stderr,"\t%lc",character_previous);
	while( (character = fgetwc(input_text)) != WEOF )
	{
		
		//if current character is a dependent vowel sign or virama,
		//then previous character and this is a single token.
		fgetpos(input_text, &pos);
		character_next = fgetwc(input_text);
		//fprintf(stderr,"\n%lc",character);
		if( is_non_printable(character) )
		{
		//	fprintf(stderr,"\nNon Printable\tSS%lcSS\n",character);
			fprintf(output_text,"%lc",character);
			fsetpos(input_text, &pos);
		}
		else if(is_d_v(character, vowels, 13))
		{

			if(character == L'\u0B83' && character_next == L'\u0BAA')
			{
				wmemset(token,L'\0',2);
				token[0] = character;
				//printf("%ls",token);
				//fsetpos(input_text, &pos);
				character_transliterated = transliterate(token);
				if(character_transliterated != NULL)
				{
					fprintf(output_text,"%ls",character_transliterated);
				}
			}
			else
			{
				wmemset(token,L'\0',2);
				token[0] = character;
				fsetpos(input_text, &pos);
				//fprintf(stderr,"\nMain Else if:\t%ls",token);
				character_transliterated = transliterate(token);
				if(character_transliterated != NULL)
				{
					fprintf(output_text,"%ls",character_transliterated);
				}
			}
		}
		else 
		{
			if(character_next == L'\u0BCD')
			{
				wmemset(token,L'\0',3);
				token[0]=character;
				token[1]=character_next;
		//		fprintf(stderr,"\n1st if:\t %ls",token);
				character_transliterated = transliterate(token);
				if(character_transliterated != NULL)
				{
					fprintf(output_text,"%ls",character_transliterated);
				}
			}
			else if(is_d_v(character, d_v, 11))
			{
				wmemset(token,L'\0',2);
				token[0]=character;
				fsetpos(input_text, &pos);
			//	fprintf(stderr,"\n1st Else if:\t%ls",token);
				character_transliterated = transliterate(token);
				if(character_transliterated != NULL)
				{
					fprintf(output_text,"%ls",character_transliterated);
				}
			}
			else if(!is_d_v(character_next, d_v, 11))
			{
				wmemset(token,L'\0',2);
				token[0] = character;
				fsetpos(input_text, &pos);
			//	fprintf(stderr,"\n2nd Else if:\t%ls",token);
				character_transliterated = transliterate(token);
				if(character_transliterated != NULL)
				{
					if(wcsncmp(token,character_transliterated,wcslen(token)) == 0)
                                        {
                                                fprintf(output_text,"%ls",character_transliterated);
                                        }
                                        else
                                                fprintf(output_text,"%lsa",character_transliterated);
				}
				
			}
			else if(is_d_v(character_next, d_v, 11))
			{
				wmemset(token,L'\0',2);
				fsetpos(input_text, &pos);
				token[0]=character;
			//	fprintf(stderr,"\n3rd Else IF:\t%ls",token);
				character_transliterated = transliterate(token);
				if(character_transliterated != NULL)
				{
					fprintf(output_text,"%ls",character_transliterated);
				}
			}
			
		}			
	}
	return 0;
}
